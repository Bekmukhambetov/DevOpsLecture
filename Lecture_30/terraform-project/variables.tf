variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "ami" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instances"
  type        = string
}

variable "project_name" {
  description = "Project name to tag resources"
  type        = string
}
