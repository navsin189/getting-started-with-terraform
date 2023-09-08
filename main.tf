terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# The access and secret can be passed along with region
# but it get the keys stored by AWS CLI
# C:\Users\<username>\.aws
provider "aws" {
  region  = "ap-south-1"
}