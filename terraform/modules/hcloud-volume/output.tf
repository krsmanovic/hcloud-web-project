output "volume_device" {
  description = "Linux volume."
  value       = hcloud_volume.volume.linux_device
}

output "id" {
  description = "Volume id."
  value       = hcloud_volume.volume.id
}
