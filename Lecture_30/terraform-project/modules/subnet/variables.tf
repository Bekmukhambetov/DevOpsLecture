variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "gateway_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_cidr" {
  description = "CIDR block for public subnet"
  type        = string
}

variable "private_cidr" {
  description = "CIDR block for private subnet"
  type        = string
}

variable "name" {
  description = "Name prefix for subnets"
  type        = string
}
