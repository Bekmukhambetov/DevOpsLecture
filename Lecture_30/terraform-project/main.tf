module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr
  name       = var.project_name
}

module "subnet" {
  source       = "./modules/subnet"
  vpc_id       = module.vpc.vpc_id
  gateway_id   = module.vpc.gateway_id
  public_cidr  = var.public_cidr
  private_cidr = var.private_cidr
  name         = var.project_name
}

module "ec2" {
  source            = "./modules/ec2"
  ami               = var.ami
  instance_type     = var.instance_type
  public_subnet_id  = module.subnet.public_subnet_id
  private_subnet_id = module.subnet.private_subnet_id
  name              = var.project_name
}