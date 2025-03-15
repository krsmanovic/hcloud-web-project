variable "application_name" {
  type        = string
  description = "Used as a resource prefix"
}

variable "hcloud_token" {
  type      = string
  default   = ""
  sensitive = true

  validation {
    condition     = length(var.hcloud_token) > 0
    error_message = "Please set Hetzner Cloud API token, e.g., by exporting TF_VAR_hcloud_token environment variable."
  }
}

variable "hcloud_location" {
  type        = string
  description = "The location name to create the server in"
  default     = "nbg1"

  validation {
    condition     = contains(["nbg1", "fsn1", "hel1", "ash"], var.hcloud_location)
    error_message = "Valid values for variable \"hcloud_location\" are: nbg1, fsn1, hel1, ash."
  }
}

variable "server_name" {
  type        = map(string)
  description = "Server hostname"
  default = {
    bastion   = "bastion"
    nextcloud = "nextcloud"
    web       = "web"
  }
}

variable "base_images" {
  type        = map(string)
  description = "Server base images"
  default = {
    bastion   = "ubuntu-22.04"
    nextcloud = "ubuntu-22.04"
    web       = "ubuntu-22.04"
  }
}

variable "server_type" {
  type        = map(string)
  description = "Type of standard (non-dedicated) Hetzner VPS offering"
  default = {
    bastion   = "cpx11" # 2 Intel vCPU cores, 2 GB RAM, 40 GB root volume size, 20 TB of traffic
    nextcloud = "cpx11"
    web       = "cpx11"
  }

  validation {
    condition     = contains(["cx11", "cpx11"], var.server_type.bastion)
    error_message = "Valid values for variable \"server_type.bastion\" are: cx11, cpx11."
  }

  validation {
    condition     = contains(["cx11", "cpx11", "cx21", "cpx21", "cx31", "cpx31", "cx41", "cpx41", "cx51", "cpx51"], var.server_type.nextcloud)
    error_message = "Valid values for variable \"server_type.nextcloud\" are: cx11, cpx11, cx21, cpx21, cx31, cpx31, cx41, cpx41, cx51, cpx51."
  }

  validation {
    condition     = contains(["cx11", "cpx11", "cx21", "cpx21", "cx31", "cpx31", "cx41", "cpx41", "cx51", "cpx51"], var.server_type.web)
    error_message = "Valid values for variable \"server_type.web\" are: cx11, cpx11, cx21, cpx21, cx31, cpx31, cx41, cpx41, cx51, cpx51."
  }
}

variable "server_base_image" {
  type        = string
  description = "Base OS image to use for server deployment"
  default     = "ubuntu-22.04"
}

variable "ssh_key_name" {
  type        = string
  description = "SSH key IDs or names which should be injected into the server at creation time"
  default     = "default"
}

variable "app_specific_labels" {
  type        = map(any)
  description = "A map of resource tags to be applied to all module resources"
  default     = {}
}

variable "nextcloud_php_version" {
  type        = string
  description = "PHP version to install on Nextcloud server."
  default     = "8.2"
}

variable "format_nextcloud_data_volume" {
  type        = string
  description = "Format data volume on the nextcloud server"
  default     = "no"

  validation {
    condition     = contains(["yes", "no"], var.format_nextcloud_data_volume)
    error_message = "Valid values for variable \"format_nextcloud_data_volume\" are: yes, no."
  }
}

variable "private_ip_address_nextcloud" {
  type        = string
  description = "IP to request to be assigned to this server. If you do not provide this then you will be auto assigned an IP address."
  default     = ""
}

variable "private_ip_address_web" {
  type        = string
  description = "IP to request to be assigned to this server. If you do not provide this then you will be auto assigned an IP address."
  default     = ""
}
