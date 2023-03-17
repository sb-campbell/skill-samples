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

# AMI ID of the latest Ubuntu image
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

####################
# Call the 'hello_world_app' module to deploy ALB, SGs, ASG and EC2s
####################

module "hello_world_app" {

  source = "../../../../modules/services/hello-world-app"

  server_text = var.server_text

  environment            = var.environment
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 2
  enable_autoscaling = false
  ami                = data.aws_ami.ubuntu.id
}
