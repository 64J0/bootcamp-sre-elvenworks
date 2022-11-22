terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.2.3"
    }
  }

  required_version = ">= 1.2.0"
}

# Conigure the AWS Provider
provider "aws" {
  region  = var.location
  profile = var.profile
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
}
