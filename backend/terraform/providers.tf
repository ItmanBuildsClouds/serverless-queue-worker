terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
  }
  backend "s3" {
    bucket = "queue-worker-<your-unique-id>"
    key    = "serverless-queue-worker/terraform/backend.tfstate"
    region = "eu-central-1"
    dynamodb_table = "queue-worker-<your-unique-id>"
  }
}
provider "aws" {
  region = "eu-central-1"
}
