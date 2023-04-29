locals {
  # hetzner
  labels = {
    AppName           = "WebProject"
    CreationTimestamp = "${formatdate("YYYYMMDDhhmmss", timestamp())}"
    IaC               = "Terraform"
  }
  # aws
  mandatory_tags = {
    AppName           = "hcloud-web-project"
    CreationTimestamp = "${timestamp()}"
    IaC               = "Terraform"
  }
}
