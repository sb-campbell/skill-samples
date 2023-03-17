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
# Call the 'mysql' module to deploy a MySQL RDS database
####################

module "mysql" {
  source = "../../../../modules/data-stores/mysql"

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}
