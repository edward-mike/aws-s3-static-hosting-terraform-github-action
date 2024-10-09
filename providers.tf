terraform {
  required_version = ">= 1.7.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    # Generate random char.
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }

  }

  backend "s3" {
    bucket = "tf-state-s3-hosting-bucket"
    key    = "terraform/state.tfstate"
    region = "us-east-1"
  }

}

provider "aws" {
  region = "us-east-1"
}
