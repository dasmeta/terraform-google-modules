"""Pure SCC normalization and grouped delivery decisions."""

import hashlib
import json
import re
from datetime import datetime, timedelta, timezone


def parse_time(value):
    if not value:
        return datetime.fromtimestamp(0, timezone.utc)
    value = re.sub(r"(\.\d{6})\d+([+-]\d{2}:\d{2}|Z)$", r"\1\2", value)
    return datetime.fromisoformat(value.replace("Z", "+00:00")).astimezone(timezone.utc)


def utc_text(value):
    return value.astimezone(timezone.utc).isoformat().replace("+00:00", "Z")


def digest_key(value):
    return hashlib.sha256(value.encode("utf-8")).hexdigest()


def should_accept_snapshot(previous, incoming):
    if not previous:
        return True
    if parse_time(previous["event_at"]) > parse_time(incoming["event_at"]):
        return False
    return (
        previous["event_at"] != incoming["event_at"]
        or previous.get("fingerprint") != incoming["fingerprint"]
    )


def delivery_due(record, now):
    if record.get("status") == "SENT":
        return False
    if record.get("status") == "SENDING":
        return parse_time(record.get("lease_until")) <= now
    return record.get("status") in {"PENDING", "RETRY"}


def reconcile_lower_bound(now, cutover_at, lookback_hours, last_success_at=""):
    lower = max(now - timedelta(hours=lookback_hours), parse_time(cutover_at))
    if last_success_at:
        lower = max(lower, parse_time(last_success_at) - timedelta(minutes=30))
    return lower


def exploit_evidence(finding):
    """Only a positive SCC field is sufficient for a HIGH page."""
    cve = (finding.get("vulnerability") or {}).get("cve") or {}
    activity = str(cve.get("exploitationActivity") or "").upper()
    if activity in {"WIDE", "CONFIRMED", "IN_THE_WILD", "ACTIVE"}:
        return True
    if cve.get("exploitReleaseDate"):
        return True
    properties = finding.get("sourceProperties") or {}
    for key in (
        "exploitAvailable",
        "exploit_available",
        "knownExploit",
        "known_exploit",
    ):
        if properties.get(key) is True or str(properties.get(key)).lower() == "true":
            return True
    return False


def public_exposure_evidence(finding):
    """Only explicit positive source facts count as public exposure."""
    properties = finding.get("sourceProperties") or {}
    for key in (
        "publicExposure",
        "public_exposure",
        "publiclyAccessible",
        "publicly_accessible",
        "internetExposed",
        "internet_exposed",
    ):
        if properties.get(key) is True or str(properties.get(key)).lower() == "true":
            return True
    return False


def normalize(payload, project_id, cutover_at):
    """Convert an SCC v2 notification or list result to a stable snapshot."""
    finding = payload.get("finding") or payload
    name = finding.get("name")
    if not name or "/findings/" not in name:
        raise ValueError("SCC finding name is missing")
    created = finding.get("createTime") or finding.get("eventTime")
    if not created:
        raise ValueError("SCC finding creation time is missing")
    if parse_time(created) < parse_time(cutover_at):
        return None
    event = finding.get("eventTime") or created
    resource = (
        finding.get("resourceName")
        or (payload.get("resource") or {}).get("name")
        or name
    )
    source = name.split("/findings/", 1)[0]
    category = finding.get("category") or "UNCATEGORIZED"
    group_id = digest_key("|".join((project_id, source, category, resource)))
    severity = str(finding.get("severity") or "UNSPECIFIED").upper()
    mute = str(finding.get("mute") or "UNMUTED").upper()
    state = str(finding.get("state") or "ACTIVE").upper()
    active = state == "ACTIVE" and mute not in {"MUTED", "DYNAMIC_MUTE"}
    snapshot = {
        "finding_id": digest_key(name),
        "name": name,
        "project_id": project_id,
        "source": source,
        "category": category,
        "resource": resource,
        "group_key": group_id,
        "group_label": f"{category} | {resource.rsplit('/', 1)[-1]}"[:200],
        "title": (finding.get("description") or category)[:250],
        "severity": severity,
        "state": state,
        "mute": mute,
        "active": active,
        "exploitable": exploit_evidence(finding),
        "public_exposure": public_exposure_evidence(finding),
        "created_at": utc_text(parse_time(created)),
        "event_at": utc_text(parse_time(event)),
    }
    snapshot["fingerprint"] = digest_key(json.dumps(snapshot, sort_keys=True))
    return snapshot


def priority(finding, config):
    if not finding.get("active"):
        return ""
    severity = finding["severity"]
    if severity == "CRITICAL" and config["paging"]["critical"]:
        return "P1"
    if (
        severity == "HIGH"
        and finding.get("exploitable")
        and config["paging"]["high_exploitable"]
        and (
            not config["paging"]["require_public_exposure"]
            or finding.get("public_exposure")
        )
    ):
        return config["paging"]["high_priority"]
    return ""


def slack_urgent(finding, config):
    if not finding.get("active"):
        return False
    if finding["severity"] == "CRITICAL":
        return config["realtime"]["critical"]
    if finding["severity"] == "HIGH":
        return (
            finding.get("exploitable")
            or not config["realtime"]["high_requires_exploit"]
        ) and (
            finding.get("public_exposure")
            or not config["realtime"]["high_requires_public_exposure"]
        )
    return False


def group_status(findings, config):
    active = [item for item in findings if item.get("active")]
    urgent = [item for item in active if slack_urgent(item, config)]
    page_priorities = {priority(item, config) for item in active}
    page_priority = (
        "P1" if "P1" in page_priorities else "P2" if "P2" in page_priorities else ""
    )
    slack_priority = (
        "CRITICAL"
        if any(item["severity"] == "CRITICAL" for item in urgent)
        else "HIGH"
        if urgent
        else ""
    )
    top = sorted(
        active,
        key=lambda x: (
            {"CRITICAL": 0, "HIGH": 1, "MEDIUM": 2, "LOW": 3}.get(x["severity"], 4),
            x["name"],
        ),
    )
    return {
        "active_count": len(active),
        "urgent_count": len(urgent),
        "slack_priority": slack_priority,
        "page_priority": page_priority,
        "top_finding": top[0] if top else None,
    }


def plan_group(previous, status, now, config, opsgenie_enabled):
    """Return new group state and deterministic action descriptors."""
    state = dict(previous or {})
    actions = []
    old_slack = state.get("slack_priority", "")
    new_slack = status["slack_priority"]
    episode = state.get("episode", 0)
    if new_slack and (
        not old_slack or new_slack == "CRITICAL" and old_slack != "CRITICAL"
    ):
        if not old_slack:
            episode += 1
        actions.append(("slack_urgent", f"slack-{episode}-{new_slack}"))
    state["episode"] = episode
    state["slack_priority"] = new_slack
    state["active_count"] = status["active_count"]
    state["updated_at"] = utc_text(now)
    wanted = status["page_priority"]
    old_wanted = state.get("current_page_priority", "")
    state["current_page_priority"] = wanted
    if new_slack or wanted:
        state["quiet_since"] = ""
    elif (old_slack or old_wanted) and not state.get("quiet_since"):
        state["quiet_since"] = utc_text(now)

    current = state.get("opsgenie_status", "CLOSED")
    if opsgenie_enabled and wanted:
        if current in {"CLOSED", "CLOSE_PENDING"}:
            actions.append(("ops_create", f"ops-create-{episode}"))
            state["opsgenie_status"] = "OPEN_PENDING"
            state["opsgenie_priority"] = wanted
        elif (
            current == "OPEN"
            and wanted == "P1"
            and state.get("opsgenie_priority") != "P1"
        ):
            actions.append(("ops_priority", f"ops-priority-{episode}-P1"))
            state["opsgenie_priority"] = "P1"
    elif opsgenie_enabled and current == "OPEN":
        quiet = parse_time(state.get("quiet_since") or utc_text(now))
        if (now - quiet).total_seconds() >= config["quiet_period_minutes"] * 60:
            actions.append(("ops_close", f"ops-close-{episode}"))
            state["opsgenie_status"] = "CLOSE_PENDING"
    if (
        not new_slack
        and state.get("quiet_since")
        and state.get("slack_quiet_sent_episode") != episode
    ):
        quiet = parse_time(state["quiet_since"])
        if (now - quiet).total_seconds() >= config["quiet_period_minutes"] * 60:
            actions.append(("slack_quiet", f"slack-quiet-{episode}"))
            state["slack_quiet_sent_episode"] = episode
    return state, actions


def slack_text(group, status, config, action):
    label = config.get("project_label") or group.get("project_id") or "GCP"
    environment = config.get("environment_label") or ""
    title = group.get("label") or "Security finding"
    finding = status.get("top_finding") or {}
    url = (
        "https://console.cloud.google.com/security/command-center/findings?project="
        + group.get("project_id", "")
    )
    if action == "urgent":
        return (
            f"{label} {environment} | {status['slack_priority']} | {title}\n"
            f"{status['active_count']} active finding(s) on this remediation target.\n"
            f"{finding.get('title', '')}\n{url}"
        )
    return (
        f"{label} {environment} | {title} | "
        f"{status['active_count']} active finding(s) | {url}"
    )
