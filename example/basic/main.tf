provider "aws" {
  region = "us-east-1"
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
  environment = "test"
  label_order = ["environment", "name"]
#   tags        = local.tags
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

data "aws_subnet_ids" "all" {
  vpc_id = module.vpc.vpc_id
}


module "documentdb" {
  source = "../../"
  vpc_id                = module.vpc.vpc_id
  subnet_list           = data.aws_subnet_ids.all.ids
  database_name         = "rds"
  environment           = "main-xcheck"
  label_order           = ["environment", "name"]
  master_password       = "test123456"

  instance_class = "db.t3.medium"
  cluster_size   = 1
}