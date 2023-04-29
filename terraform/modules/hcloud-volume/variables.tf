variable "server_name" {
  type        = string
  description = "Server hostname."
}

variable "hcloud_location" {
  type        = string
  description = "The location name to create the volume in"
  default     = "nbg1"

  validation {
    condition     = contains(["nbg1", "fsn1", "hel1", "ash"], var.hcloud_location)
    error_message = "Valid values for variable \"hcloud_location\" are: nbg1, fsn1, hel1, ash."
  }
}

variable "volume_name" {
  type        = string
  description = "Volume name."
  default     = "data"
}

variable "volume_size" {
  type        = number
  description = "Size of the volume (in GB)."
  default     = 50
}

variable "automount_volume" {
  type        = bool
  description = "Automount the volume upon attaching it."
  default     = true
}


variable "volume_format" {
  type        = string
  description = "Format the volume after creation in ext4 or xfs."
  default     = "ext4"

  validation {
    condition     = contains(["ext4", "xfs"], var.volume_format)
    error_message = "Valid values for variable \"volume_format\" are: ext4, xfs."
  }
}

variable "generic_labels" {
  type        = map(any)
  description = "A map of resource tags to be applied to all module resources"
  default     = {}
}
