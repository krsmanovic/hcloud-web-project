variable "rule_type" {
  type        = string
  description = "Type of the server rule to deploy"
  default     = "bastion"

  validation {
    condition     = contains(["bastion", "web"], var.rule_type)
    error_message = "Valid values for variable \"rule_type\" are: bastion, web."
  }
}

variable "name_prefix" {
  type        = string
  description = "Prefix to apply to firewall name"
  default     = ""
}


variable "generic_labels" {
  type        = map(any)
  description = "A map of resource tags to be applied to all module resources"
  default     = {}
}

variable "source_ip_cidrs" {
  type        = list(string)
  description = "Source IP addresses reqired for access"
  default     = ["0.0.0.0/0"]
}