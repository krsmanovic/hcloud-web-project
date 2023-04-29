resource "hcloud_firewall" "bastion" {
  count = var.rule_type == "bastion" ? 1 : 0
  name  = "${var.name_prefix}bastion-firewall"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = var.source_ip_cidrs
  }

  labels = merge(var.generic_labels, local.module_labels)

  lifecycle {
    ignore_changes = [
      labels["CreationTimestamp"],
    ]
  }
}

resource "hcloud_firewall" "web" {
  count = var.rule_type == "web" ? 1 : 0
  name  = "${var.name_prefix}web-firewall"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = var.source_ip_cidrs
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0"]
  }

  labels = merge(var.generic_labels, local.module_labels)

  lifecycle {
    ignore_changes = [
      labels["CreationTimestamp"],
    ]
  }
}