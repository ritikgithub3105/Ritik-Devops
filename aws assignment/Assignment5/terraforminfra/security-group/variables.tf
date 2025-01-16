variable "vpc_id" {
  description = "VPC ID for security group"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed for ingress"
  type        = list(string)
}

variable "security_group_name" {
  description = "Name for the security group"
  type        = string
}
