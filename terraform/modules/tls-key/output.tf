output "key_id" {
  value       = hcloud_ssh_key.public_key.id
  description = "ID of the created SSH key"
}

output "key_name" {
  value       = hcloud_ssh_key.public_key.name
  description = "Name of the created SSH key"
}

output "public_key" {
  value       = hcloud_ssh_key.public_key.public_key
  description = "Public SSH key"
}

output "private_key" {
  value       = tls_private_key.key_pair.private_key_openssh
  description = "Private OpenSSH key"
}

output "private_key_ssm_paremeter_id" {
  value       = aws_ssm_parameter.private_key.id
  description = "ID of the parameter store private key"
}

output "private_key_ssm_paremeter_name" {
  value       = aws_ssm_parameter.private_key.name
  description = "Name of the parameter store private key"
}

output "public_key_ssm_paremeter_id" {
  value       = aws_ssm_parameter.public_key.id
  description = "ID of the parameter store public key"
}

output "public_key_ssm_paremeter_name" {
  value       = aws_ssm_parameter.public_key.name
  description = "Name of the parameter store public key"
}