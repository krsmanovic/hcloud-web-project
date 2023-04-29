output "name" {
  value       = aws_s3_bucket.terraform_state.bucket
  description = "Name of the S3 bucket used to store all terraform remote state files"
}
