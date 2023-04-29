output "bastion_id" {
  description = "Firewall ID"
  value       = try(hcloud_firewall.bastion[*].id)
}

output "web_id" {
  description = "Firewall ID"
  value       = try(hcloud_firewall.web[*].id)
}