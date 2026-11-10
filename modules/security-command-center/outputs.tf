output "notification_config_id" {
  description = "SCC v2 project notification config ID."
  value       = google_scc_v2_project_notification_config.findings.id
}

output "function_uri" {
  description = "Authenticated Cloud Run function URL."
  value       = google_cloudfunctions2_function.router.service_config[0].uri
}

output "findings_subscription" {
  description = "Pub/Sub push subscription delivering SCC findings."
  value       = google_pubsub_subscription.findings.id
}

output "dead_letter_subscription" {
  description = "Pull subscription for failed finding messages."
  value       = google_pubsub_subscription.dead_letter.id
}

output "runtime_service_account" {
  description = "Function service account."
  value       = google_service_account.runtime.email
}

output "cutover_at" {
  description = "Preserved UTC creation cutoff."
  value       = local.cutover_at
}
