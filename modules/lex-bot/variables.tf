variable "bot_config" {
  description = "Decoded JSON bot configuration"
  type        = any
}

variable "environment" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "locale_id" {
  type = string
  default = "en_GB"
}
