# we are declaring provider source in the module due to a bug in TF where it is automatically referencing nonexistent hashicorp/hcloud source
terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}
