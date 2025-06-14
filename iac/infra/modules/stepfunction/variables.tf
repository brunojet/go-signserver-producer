variable "name" { type = string }
variable "definition" { type = string }
variable "tags" {
  description = "Tags para o Step Function"
  type        = map(string)
  default     = {}
}
