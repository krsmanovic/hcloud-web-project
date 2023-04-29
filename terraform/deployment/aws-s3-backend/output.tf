output "tf_state_lock_dynamodb_table_name" {
  value       = module.dynamodb_state_lock_table.table_name
  description = "Name of the DynamoDB terraform state lock table"
}

output "tf_state_s3_bucket_name" {
  value       = module.s3_state_bucket.name
  description = "Name of the S3 bucket used to store all terraform remote state files"
}
