terraform {
  backend "s3" {
    bucket         = "S3_Bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

data "aws_vpc" "default" {
  filter {
    name   = "isDefault"
    values = ["true"]
  }
}

# Additional resources (VPC, subnets, EC2 instances, etc.)
