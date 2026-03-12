locals {
  hosts_and_paths = [
    {
      name         = "example.com"
      host         = "example.com"
      health_check = true
      path         = "/"
    },
    {
      name         = "example.com/mobile/"
      host         = "example.com"
      health_check = true
      path         = "/mobile/"
    },
  ]
}

module "uptime_checks" {
  source = "../../"

  for_each = { for item in local.hosts_and_paths : item.name => item if item.health_check }

  enable_email_notifiacation   = false
  enable_slack_notifiacation   = true
  enable_webhook_notifications = true
  webhook_integration_url      = "https://api.opsgenie.com/v1/json/googlestackdriver?apiKey=xxxxxxxxxxxx" //In this example opsgenie webhook url is used
  project_id                   = "my-project"
  selected_regions             = ["SOUTH_AMERICA", "EUROPE", "ASIA_PACIFIC"]
  display_name                 = each.value.name
  checker_location             = "sa-brazil-sao_paulo"
  name                         = each.value.host
  channel_name                 = "#alert-notifications"
  auth_token                   = "xoxb-xxxxxxxxx" //Slack auth token
  http_check = {
    path = each.value.path
  }
  documentation_content = each.value.name
}
