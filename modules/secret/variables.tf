variable "secrets" {
  description = "Map of secrets where key is the secret name and value is the secret data"
  type        = map(string)
}

variable "labels" {
  description = "Custom labels to apply to the secret"
  type        = map(string)
  default     = {}
}
