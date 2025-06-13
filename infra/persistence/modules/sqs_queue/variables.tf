variable "name" { type = string }

variable "visibility_timeout_seconds" {
  type    = number
  default = 30
}

variable "message_retention_seconds" {
  type    = number
  default = 345600
}

variable "delay_seconds" {
  type    = number
  default = 0
}

variable "max_message_size" {
  type    = number
  default = 262144
}

variable "receive_wait_time_seconds" {
  type    = number
  default = 0
}

variable "redrive_policy" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
