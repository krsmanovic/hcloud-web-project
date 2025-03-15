output "bastion_public_ip" {
  value       = module.bastion_server.public_ip
  description = "Bastion public IPV4 address"
}

output "nextcloud_public_ip" {
  value       = module.nextcloud_server.public_ip
  description = "Nextcloud public IPV4 address"
}

output "web_public_ip" {
  value       = module.web_server.public_ip
  description = "Web server public IPV4 address"
}
