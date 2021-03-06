variable "project_id" {
  type        = string
  description = "Google cloud project id"
}

variable "name" {
  type        = string
  description = "zone name"
}

variable "description" {
  type        = string
  description = "Dns zone description"
  default     = ""
}

variable "key_path" {
  type        = string
  description = "key.json folder"
  default     = ""
}
