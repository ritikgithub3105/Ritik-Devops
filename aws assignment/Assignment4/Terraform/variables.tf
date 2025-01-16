variable "vpc_cidr_range" {
  type    = string
  default = "10.0.0.0/16"
}

variable "ami_id" {
  type    = string
  default = "ami-ami-01816d07b1128cd2d"
}

# Other variables for subnets, availability zones, security groups, etc.
