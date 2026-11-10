"""Authenticated SCC Pub/Sub receiver and scheduled grouped delivery worker."""

import base64
import json
import logging
import os
import time
import urllib.error
import urllib.parse
import urllib.request
from datetime import datetime, timedelta, timezone

import functions_framework
from core import (
    delivery_due,
    digest_key,
    group_status,
    normalize,
    plan_group,
    reconcile_lower_bound,
    should_accept_snapshot,
    slack_text,
    utc_text,
)
from google.cloud import firestore, securitycenter_v2
from google.cloud.firestore_v1.base_query import FieldFilter
from google.protobuf.json_format import MessageToDict

LOG = logging.getLogger(__name__)
PROJECT = os.environ["PROJECT_ID"]
LOCATION = os.environ["SCC_LOCATION"]
SCC_FILTER = os.environ["SCC_FILTER"]
PREFIX = os.environ["COLLECTION_PREFIX"]
CUTOVER = os.environ["CUTOVER_AT"]
CONFIG = json.loads(os.environ["ROUTING_CONFIG"])
OPS_ENABLED = os.environ.get("OPSGENIE_ENABLED") == "true"
OPS_URL = os.environ.get("OPSGENIE_API_URL", "https://api.opsgenie.com")
DB = firestore.Client(project=PROJECT, database=os.environ["FIRESTORE_DATABASE"])


def collection(suffix):
    return DB.collection(f"{PREFIX}_{suffix}")


def _read_secret(path):
    with open(path, encoding="utf-8") as stream:
        return stream.read().strip()


def _http_json(url, payload, headers, method="POST"):
    data = json.dumps(payload).encode("utf-8") if payload is not None else None
    request = urllib.request.Request(url, data=data, headers=headers, method=method)
    with urllib.request.urlopen(request, timeout=15) as response:
        body = response.read(16384)
        return response.status, json.loads(body) if body and body[:1] in (
            b"{",
            b"[",
        ) else body.decode("utf-8", "replace")


def _opsgenie(action, payload):
    key = _read_secret("/secrets/opsgenie/api_key")
    headers = {"Authorization": f"GenieKey {key}", "Content-Type": "application/json"}
    alias = urllib.parse.quote(payload["alias"], safe="")
    if action == "ops_create":
        path = "/v2/alerts"
        method = "POST"
        body = {
            "alias": payload["alias"],
            "message": payload["message"],
            "priority": payload["priority"],
            "description": payload["description"],
            "tags": ["scc-grouped"],
        }
    elif action == "ops_priority":
        path = f"/v2/alerts/{alias}/priority?identifierType=alias"
        method = "PUT"
        body = {"priority": payload["priority"]}
    else:
        path = f"/v2/alerts/{alias}/close?identifierType=alias"
        method = "POST"
        body = {"note": "All actionable SCC findings in this group are quiet."}
    try:
        _, response = _http_json(OPS_URL + path, body, headers, method)
    except urllib.error.HTTPError as error:
        raise RuntimeError(f"Opsgenie {action} HTTP {error.code}") from None
    except urllib.error.URLError:
        raise RuntimeError(f"Opsgenie {action} transport failure") from None
    request_id = response.get("requestId") if isinstance(response, dict) else None
    if request_id:
        for delay in (0.5, 1, 2, 4, 4):
            time.sleep(delay)
            try:
                _, status = _http_json(
                    OPS_URL
                    + "/v2/alerts/requests/"
                    + urllib.parse.quote(request_id, safe=""),
                    None,
                    headers,
                    "GET",
                )
            except urllib.error.HTTPError as error:
                raise RuntimeError(
                    f"Opsgenie request status HTTP {error.code}"
                ) from None
            except urllib.error.URLError:
                raise RuntimeError(
                    "Opsgenie request status transport failure"
                ) from None
            result = status.get("data") or {}
            if result.get("isSuccess") is True:
                return
            if result.get("isSuccess") is False:
                raise RuntimeError(
                    f"Opsgenie rejected {action}: {result.get('status', 'unknown')}"
                )
        raise RuntimeError(
            f"Opsgenie {action} request did not finish before the poll limit"
        )


def _send(action, payload):
    if action.startswith("slack_"):
        webhook = _read_secret("/secrets/slack/webhook")
        try:
            status, body = _http_json(
                webhook, {"text": payload["text"]}, {"Content-Type": "application/json"}
            )
        except urllib.error.HTTPError as error:
            raise RuntimeError(f"Slack HTTP {error.code}") from None
        except urllib.error.URLError:
            raise RuntimeError("Slack transport failure") from None
        if status != 200 or body != "ok":
            raise RuntimeError(f"Slack rejected {action}: HTTP {status}")
    else:
        _opsgenie(action, payload)


def save_finding(snapshot):
    if not snapshot["active"]:
        snapshot["expires_at"] = datetime.now(timezone.utc) + timedelta(
            days=CONFIG["finding_retention_days"]
        )
    ref = collection("findings").document(snapshot["finding_id"])
    transaction = DB.transaction()

    @firestore.transactional
    def update(tx):
        previous = ref.get(transaction=tx)
        old = previous.to_dict() if previous.exists else None
        if not should_accept_snapshot(old, snapshot):
            return False, None
        tx.set(ref, snapshot)
        return True, old.get("group_key") if old else None

    return update(transaction)


def group_findings(key):
    query = (
        collection("findings")
        .where(filter=FieldFilter("group_key", "==", key))
        .limit(1001)
    )
    findings = [item.to_dict() for item in query.stream()]
    if len(findings) > 1000:
        raise RuntimeError(
            "Remediation group exceeds 1000 findings; split the route before retrying"
        )
    return findings


def _action_payload(action, state, status):
    alias = "scc-group-" + state["group_key"]
    url = (
        "https://console.cloud.google.com/security/command-center/findings?project="
        + state["project_id"]
    )
    if action == "slack_urgent":
        return {"text": slack_text(state, status, CONFIG, "urgent")}
    if action == "slack_quiet":
        return {
            "text": (
                f"{CONFIG.get('project_label') or state['project_id']} | "
                f"Quiet after {CONFIG['quiet_period_minutes']} min | "
                f"{state['label']}\n{url}"
            )
        }
    if action == "ops_create":
        return {
            "alias": alias,
            "message": (
                f"{CONFIG.get('project_label') or state['project_id']} "
                f"Security {status['page_priority']}: Investigate {state['label']}"
            )[:130],
            "priority": status["page_priority"],
            "description": (
                f"Action: Investigate {state['label']}\n"
                f"Active findings: {status['active_count']}\n{url}"
            ),
        }
    if action == "ops_priority":
        return {"alias": alias, "priority": status["page_priority"]}
    return {"alias": alias}


def process_group(key, now=None):
    now = now or datetime.now(timezone.utc)
    findings = group_findings(key)
    status = group_status(findings, CONFIG)
    group_ref = collection("groups").document(key)
    transaction = DB.transaction()

    @firestore.transactional
    def stage(tx):
        previous_doc = group_ref.get(transaction=tx)
        previous = previous_doc.to_dict() if previous_doc.exists else {}
        top = status["top_finding"] or (findings[0] if findings else {})
        state, actions = plan_group(previous, status, now, CONFIG, OPS_ENABLED)
        state.update(
            {
                "group_key": key,
                "project_id": top.get("project_id")
                or previous.get("project_id")
                or PROJECT,
                "label": top.get("group_label")
                or previous.get("label")
                or "Security finding",
            }
        )
        pending = []
        for action, action_id in actions:
            delivery_id = digest_key("|".join((key, action_id)))
            ref = collection("deliveries").document(delivery_id)
            if not ref.get(transaction=tx).exists:
                pending.append(
                    (
                        ref,
                        {
                            "action": action,
                            "group_key": key,
                            "episode": state["episode"],
                            "status": "PENDING",
                            "lease_until": "",
                            "attempts": 0,
                            "payload": _action_payload(action, state, status),
                            "created_at": utc_text(now),
                        },
                    )
                )
        tx.set(group_ref, state)
        for ref, delivery in pending:
            tx.create(ref, delivery)
        return len(pending)

    return stage(transaction)


def _claim_delivery(ref, now):
    transaction = DB.transaction()

    @firestore.transactional
    def claim(tx):
        doc = ref.get(transaction=tx)
        if not doc.exists:
            return None
        record = doc.to_dict()
        if not delivery_due(record, now):
            return None
        group_doc = (
            collection("groups").document(record["group_key"]).get(transaction=tx)
        )
        group = group_doc.to_dict() if group_doc.exists else {}
        if record["action"] == "ops_close" and (
            group.get("current_page_priority")
            or group.get("episode") != record["episode"]
        ):
            tx.update(ref, {"status": "SENT", "last_error": "Obsolete close skipped"})
            return None
        tx.update(
            ref,
            {
                "status": "SENDING",
                "lease_until": utc_text(now + timedelta(minutes=3)),
                "attempts": record.get("attempts", 0) + 1,
            },
        )
        return record

    return claim(transaction)


def deliver(ref, now=None):
    now = now or datetime.now(timezone.utc)
    record = _claim_delivery(ref, now)
    if not record:
        return False
    try:
        _send(record["action"], record["payload"])
    except Exception as error:
        safe_error = (
            f"{type(error).__name__}: HTTP {error.code}"
            if isinstance(error, urllib.error.HTTPError)
            else str(error)[:300]
        )
        ref.update({"status": "RETRY", "lease_until": "", "last_error": safe_error})
        LOG.warning("Delivery %s failed: %s", ref.id, type(error).__name__)
        raise
    transaction = DB.transaction()

    @firestore.transactional
    def finish(tx):
        group_ref = collection("groups").document(record["group_key"])
        if record["action"] in {"ops_create", "ops_close"}:
            group_doc = group_ref.get(transaction=tx)
            group = group_doc.to_dict() if group_doc.exists else {}
            if group.get("episode") == record["episode"]:
                tx.update(
                    group_ref,
                    {
                        "opsgenie_status": "OPEN"
                        if record["action"] == "ops_create"
                        else "CLOSED"
                    },
                )
        tx.update(
            ref,
            {
                "status": "SENT",
                "lease_until": "",
                "sent_at": utc_text(datetime.now(timezone.utc)),
                "last_error": "",
            },
        )

    finish(transaction)
    return True


def dispatch_pending(limit=100):
    query = (
        collection("deliveries")
        .where(filter=FieldFilter("status", "in", ["PENDING", "RETRY", "SENDING"]))
        .limit(limit)
    )
    count = 0
    for doc in query.stream():
        if deliver(doc.reference):
            count += 1
    return count


def process_finding(payload):
    snapshot = normalize(payload, PROJECT, CUTOVER)
    if not snapshot:
        return False
    changed, old_group = save_finding(snapshot)
    if changed:
        for key in {snapshot["group_key"], old_group} - {None}:
            process_group(key)
    return changed


def reconcile_scc(now):
    checkpoint_ref = collection("checkpoints").document("scc")
    checkpoint_doc = checkpoint_ref.get()
    checkpoint = checkpoint_doc.to_dict() if checkpoint_doc.exists else {}
    lower = reconcile_lower_bound(
        now,
        CUTOVER,
        CONFIG["reconcile_lookback_hours"],
        checkpoint.get("last_success_at", ""),
    )
    parent = f"projects/{PROJECT}/sources/-/locations/{LOCATION}"
    client = securitycenter_v2.SecurityCenterClient()
    items = client.list_findings(
        request={
            "parent": parent,
            "filter": f'({SCC_FILTER}) AND eventTime >= "{utc_text(lower)}"',
            "page_size": 100,
        }
    )
    count = 0
    for item in items:
        finding = MessageToDict(item.finding._pb, preserving_proto_field_name=False)
        process_finding({"finding": finding})
        count += 1
        if count >= 3000:
            raise RuntimeError(
                "SCC reconciliation reached 3000 findings; "
                "reduce lookback or shard the route"
            )
    checkpoint_ref.set({"last_success_at": utc_text(now)}, merge=True)
    return count


def send_daily_digest(now):
    daily = CONFIG["daily_digest"]
    if not daily["enabled"] or now.hour < daily["hour_utc"]:
        return False
    day = now.date().isoformat()
    ref = collection("deliveries").document(digest_key("daily|" + day))
    if ref.get().exists:
        return False
    summaries = []
    for doc in collection("groups").stream():
        group = doc.to_dict()
        if not group.get("active_count"):
            continue
        findings = group_findings(doc.id)
        status = group_status(findings, CONFIG)
        if status["active_count"]:
            summaries.append(
                (
                    0
                    if status["slack_priority"] == "CRITICAL"
                    else 1
                    if status["slack_priority"] == "HIGH"
                    else 2,
                    group,
                    status,
                )
            )
    summaries.sort(
        key=lambda item: (item[0], -item[2]["active_count"], item[1]["label"])
    )
    lines = [
        f"{CONFIG.get('project_label') or PROJECT} security brief — {day} UTC",
        f"{len(summaries)} active remediation group(s)",
    ]
    for _, group, status in summaries[: daily["max_groups"]]:
        lines.append("• " + slack_text(group, status, CONFIG, "digest"))
    if len(summaries) > daily["max_groups"]:
        lines.append(
            f"…and {len(summaries) - daily['max_groups']} more groups "
            "in Security Command Center"
        )
    try:
        ref.create(
            {
                "action": "slack_digest",
                "group_key": "daily",
                "episode": day,
                "status": "PENDING",
                "lease_until": "",
                "attempts": 0,
                "payload": {"text": "\n".join(lines)},
                "created_at": utc_text(now),
            }
        )
    except Exception as error:
        if type(error).__name__ != "Conflict":
            raise
        return False
    return True


def reconcile():
    now = datetime.now(timezone.utc)
    source_count = reconcile_scc(now)
    for doc in collection("groups").stream():
        process_group(doc.id, now)
    send_daily_digest(now)
    sent = dispatch_pending()
    return {"reconciled": source_count, "sent": sent}


@functions_framework.http
def route_request(request):
    body = request.get_json(silent=True) or {}
    if body.get("action") == "reconcile":
        try:
            return (json.dumps(reconcile()), 200, {"Content-Type": "application/json"})
        except Exception:
            LOG.exception("SCC reconciliation failed")
            return ("reconciliation failed", 500)
    message = body.get("message") or {}
    if not message.get("data"):
        return ("Pub/Sub message data required", 400)
    try:
        payload = json.loads(base64.b64decode(message["data"], validate=True))
        process_finding(payload)
        dispatch_pending()
        return ("ok", 200)
    except ValueError:
        LOG.exception("Invalid SCC notification")
        return ("invalid SCC notification", 400)
    except Exception:
        LOG.exception("SCC notification processing failed")
        return ("processing failed", 500)
