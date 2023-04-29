provider "aws" {
  region = "eu-central-1"
}

module "s3_state_bucket" {
  source           = "../../modules/aws-s3"
  application_name = var.application_name
  additional_tags  = var.additional_tags
}

module "dynamodb_state_lock_table" {
  source           = "../../modules/aws-dynamodb"
  application_name = var.application_name
  additional_tags  = var.additional_tags
}
