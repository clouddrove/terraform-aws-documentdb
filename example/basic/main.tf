provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "0.15.1"

  name        = "vpc"
  environment = "test"
  label_order = ["name", "environment"]

  cidr_block = "172.16.0.0/16"
}

module "subnets" {
  source  = "clouddrove/subnet/aws"
  version = "1.0.1"

  name        = "subnets"
  environment = "sandbox"
  label_order = ["environment", "name"]
  enabled     = true

  nat_gateway_enabled = true
  single_nat_gateway  = true
  availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_id              = module.vpc.vpc_id
  cidr_block          = module.vpc.vpc_cidr_block
  ipv6_cidr_block     = module.vpc.ipv6_cidr_block
  type                = "public-private"
  igw_id              = module.vpc.igw_id
}

module "documentdb" {
  source = "../../"
  database_name         = "rds"
  environment           = "test"
  vpc_id                = module.vpc.vpc_id
  subnet_list           = module.subnets.private_subnet_id
  label_order           = ["environment", "name"]
  master_password       = var.master_password
  instance_class        = var.instance_class
  cluster_size          = var.cluster_size
  deletion_protection   = true
}