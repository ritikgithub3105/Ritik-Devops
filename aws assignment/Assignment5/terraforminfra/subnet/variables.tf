variable "vpc_id" {
  description = "The VPC ID to associate the subnet with"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone"
  type        = string
}

variable "map_public_ip" {
  description = "If true, instances launched in this subnet will have public IPs"
  type        = bool
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}
