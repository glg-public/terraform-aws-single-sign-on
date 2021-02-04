variable "inline_policy" {
  type        = string
  description = "Inline policy as JSON. LIMIT 1 per permission set."
  default     = ""
}

variable "managed_policies" {
  type        = list(string)
  description = "List of AWS managed policies."
  default     = []
}

variable "permission_set_name" {
  type        = string
  description = "Descriptive name of permission set."
}

variable "permission_set_description" {
  type        = string
  description = "The description of the Permission Set."
}

variable "session_duration" {
  type        = string
  description = "The lenght of the session. ISO-8601 standard."
}

variable "principal_group_id" {
  type        = list(string)
  description = "The Active Directory group the permission set will be applied to."
  default     = []
}

variable "principal_user_id" {
  type        = list(string)
  description = "The Active Directory user the permission set will be applied to."
  default     = []
}

variable "account_ids" {
  type        = list(string)
  description = "An AWS account identifier, typically a 10-12 digit string."
}