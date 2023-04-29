resource "hcloud_volume" "volume" {
  name      = "${var.server_name}-${var.volume_name}-volume"
  size      = var.volume_size
  location  = var.hcloud_location
  automount = var.automount_volume
  format    = var.volume_format
  labels    = merge(var.generic_labels, local.module_labels)

  lifecycle {
    ignore_changes = [
      labels["CreationTimestamp"],
    ]
  }
}