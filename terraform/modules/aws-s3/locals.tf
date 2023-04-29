locals {
  mandatory_tags = {
    AppName           = "${var.application_name}"
    CreationTimestamp = "${timestamp()}"
    OrchestrationTool = "Terraform"
  }
}
