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
  version = "0.15.3"

  name               = "subnets"
  environment        = "test"
  label_order        = ["name", "environment"]
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  vpc_id             = module.vpc.vpc_id
  type               = "public"
  igw_id             = module.vpc.igw_id
  cidr_block         = module.vpc.vpc_cidr_block
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
}

module "documentdb" {
  source = "../../"
  database_name         = "rds"
  environment           = "test"
  vpc_id                = module.vpc.vpc_id
  subnet_list           = data.aws_subnet_ids.all.ids
  label_order           = ["environment", "name"]
  master_password       = var.master_password
  instance_class        = var.instance_class
  cluster_size          = var.cluster_size
}