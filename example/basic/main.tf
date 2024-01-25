provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "2.0.0"

  name        = "vpc"
  environment = "test"
  label_order = ["name", "environment"]

  cidr_block = "172.16.0.0/16"
}

module "subnets" {
  source  = "clouddrove/subnet/aws"
  version = "2.0.1"

  name        = "subnets"
  environment = "sandbox"
  label_order = ["environment", "name"]

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
  source              = "../../"
  enable              = true
  environment         = "test"
  label_order         = ["environment", "name"]
  subnet_list         = module.subnets.private_subnet_id
  database_name       = "test-db"
  master_username     = "test"
  master_password     = var.master_password
  instance_class      = var.instance_class
  cluster_size        = var.cluster_size
  deletion_protection = true
}