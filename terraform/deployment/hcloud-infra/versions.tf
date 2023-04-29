terraform {
  required_version = ">= 1.2.9"
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }

  backend "s3" {
    key            = "hcloud-web-project.tfstate"
    bucket         = "hcloud-web-project-tf-state-bucket"
    region         = "eu-central-1"
    dynamodb_table = "hcloud-web-project-tf-state-lock"
  }
}

provider "hcloud" {
  token = var.hcloud_token
}
