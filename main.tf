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

###### Syntax ######
# resource "provider_resource_name" "unique_name_for_the_resource_provided_by_you" {
#     key1   = value1
#     key2   = value2
#     key3   = value3
#     key4   = value4
#     value can be list, string, dictionary
# }
###### Syntax ######
