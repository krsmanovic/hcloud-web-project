resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "${var.application_name}-tf-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(local.mandatory_tags, var.additional_tags)

  lifecycle {
    ignore_changes = [
      tags["CreationTimestamp"],
    ]
  }
}