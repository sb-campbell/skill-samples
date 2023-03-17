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

# AMI ID of the latest ubuntu image
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

####################
# Call the 'asg' module to deploy an auto scaling group of EC2 instances
####################

module "asg" {
  source = "../../modules/cluster/asg-rolling-deploy"

  cluster_name = var.cluster_name

  # ami of latest ubuntu retrieved above
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  min_size           = 1
  max_size           = 1
  enable_autoscaling = false

  # subnet_ids data retrieved above
  subnet_ids = data.aws_subnets.default.ids
}
