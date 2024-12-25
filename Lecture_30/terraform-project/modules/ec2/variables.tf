variable "ami" {
  description = "AMI ID for the instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the private subnet"
  type        = string
}

variable "name" {
  description = "Name prefix for instances"
  type        = string
}
