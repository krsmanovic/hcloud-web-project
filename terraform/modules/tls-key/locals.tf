locals {
  # aws
  module_tags = merge(local.module_specific_tags, var.generic_tags)

  module_specific_tags = {
    Description = "TLS key"
  }
  # hetzner
  module_labels = merge(local.module_specific_labels, var.generic_labels)

  module_specific_labels = {
    Description = "Network"
  }
}
