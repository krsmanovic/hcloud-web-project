# Generate a secure private key
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "public_key" {
  name       = "${var.application_name}-key"
  public_key = tls_private_key.key_pair.public_key_openssh
  labels     = merge(var.generic_labels, local.module_labels)

  lifecycle {
    ignore_changes = [
      labels["CreationTimestamp"],
    ]
  }
}

# Save private and public key in AWS SSM parameter store and (optionally) on the local file system
resource "aws_ssm_parameter" "private_key" {
  name        = "/hcloud/${var.application_name}/server/key/private"
  description = "Private SSH key for ops user on ${var.application_name} EC2 instances"
  type        = "SecureString"
  value       = tls_private_key.key_pair.private_key_pem

  tags = local.module_tags

  lifecycle {
    ignore_changes = [
      tags["CreationTimestamp"],
    ]
  }
}

resource "aws_ssm_parameter" "public_key" {
  name        = "/hcloud/${var.application_name}/server/key/public"
  description = "Public SSH key for ops user on ${var.application_name} EC2 instances"
  type        = "SecureString"
  value       = tls_private_key.key_pair.public_key_pem

  tags = local.module_tags

  lifecycle {
    ignore_changes = [
      tags["CreationTimestamp"],
    ]
  }
}

resource "local_file" "private_key" {
  count    = var.store_locally ? 1 : 0
  filename = "${path.root}/keys/${hcloud_ssh_key.public_key.name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}

resource "local_file" "public_key" {
  count    = var.store_locally ? 1 : 0
  filename = "${path.root}/keys/${hcloud_ssh_key.public_key.name}.pub"
  content  = tls_private_key.key_pair.public_key_openssh
}