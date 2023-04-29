output "public_ip" {
  description = "Server public IP address."
  value       = hcloud_server.server.ipv4_address
}

output "server_id" {
  description = "Server ID."
  value       = hcloud_server.server.id
}
