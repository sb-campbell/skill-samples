terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # OPTIONAL...
  # Backend block to configure S3 storage for tf state
  #  backend "s3" {
  #
  #    # REPLACE THIS WITH BUCKET NAME
  #    bucket         = "{S3 bucket name}"
  #
  #    # THIS MUST BE A UNIQUE KEY TO EACH TERRAFORM MODULE OR SCRIPT!!!
  #    key            = "{path to module}/terraform.tfstate"
  #
  #    region         = "{region of the S3 bucket}"
  #
  #    # REPLACE THIS WITH DYNAMODB TABLE NAME!
  #    dynamodb_table = "{TF state lock table name}"
  #
  #    encrypt        = true
  #  }
}

provider "aws" {
  region = "us-east-1"
}

####################
# Data gathering
####################

# VPC
data "aws_vpc" "default" {
  default = true
}

# List of subnets in the VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

####################
# Call the 'alb' module to deploy an application load balancer
####################

module "alb" {
  source = "../../modules/networking/alb"

  alb_name   = var.alb_name
  subnet_ids = data.aws_subnets.default.ids
}
