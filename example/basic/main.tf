provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "1.3.0"

  name        = "vpc"
  environment = "test"
  label_order = ["name", "environment"]

  cidr_block = "172.16.0.0/16"
}

module "subnets" {
  source  = "clouddrove/subnet/aws"
  version = "1.3.0"

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
  source                  = "../../"
  environment             = "test"
  label_order             = ["environment", "name"]
  vpc_id                  = module.vpc.vpc_id
  subnet_list             = module.subnets.private_subnet_id
  database_name           = "test-db"
  master_username         = "test"
  master_password         = "QfbaJpP00W0m413Bw1fe"
  skip_final_snapshot     = false
  storage_encrypted       = true
  kms_key_id              = module.kms_key.key_arn
  tls_enabled             = true
  instance_class          = "db.t3.medium"
  cluster_size            = 2
  cluster_family          = "docdb5.0"
  deletion_protection     = true
  preferred_backup_window = "07:00-07:30"

}