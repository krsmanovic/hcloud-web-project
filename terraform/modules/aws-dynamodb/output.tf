output "table_name" {
  value       = aws_dynamodb_table.terraform_state_lock.name
  description = "Name of the DynamoDB terraform state lock table"
}
