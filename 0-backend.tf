terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22"
    }
  }

  required_version = ">= 0.14.9"

  backend "s3" {
    bucket  = "your-state-files"       # Name of the S3 bucket
    key     = "your-file.tfstate"      # The name of the state file in the bucket
    region  = "us-east-1"              # Use a variable for the region
    encrypt = true                     # Enable server-side encryption (optional but recommended)
  }
}

provider "aws" {
  region = "us-east-1" # Change to your desired region
}
