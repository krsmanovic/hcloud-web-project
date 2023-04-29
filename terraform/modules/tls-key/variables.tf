variable "application_name" {
  type        = string
  description = "Resource prefixed added to all resources"
}

variable "store_locally" {
  type        = bool
  description = "Enable storing keys on the local file system"
  default     = false
}

variable "generic_tags" {
  type        = map(any)
  description = "A map of resource tags to be applied to all module resources"
  default     = {}
}

variable "generic_labels" {
  type        = map(any)
  description = "A map of resource tags to be applied to all module resources"
  default     = {}
}
