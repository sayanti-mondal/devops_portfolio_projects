# terraform/versions.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use a compatible version
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
}