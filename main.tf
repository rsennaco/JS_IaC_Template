# Establish TF
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Provider config
provider "aws" {
    region = var.region
}