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
  environment = "main-xcheck"
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

data "aws_subnet_ids" "all" {
  vpc_id = module.vpc.vpc_id
}

locals {
  project     = "test"
  environment = "dev"
  env_project = "${local.environment}-${local.project}"
}

data "aws_iam_policy_document" "default" {
  version = "2012-10-17"
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
  statement {
    sid    = "Allow alias creation during setup"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["kms:CreateAlias"]
    resources = ["*"]
  }
}


module "kms_key" {
  source                  = "clouddrove/kms/aws"
  version                 = "1.0.1"
  name                    = "kms"
  environment             = "test"
  label_order             = ["environment", "name"]
  enabled                 = true
  description             = "KMS key for ec2"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  alias                   = "alias/ec2"
  policy                  = data.aws_iam_policy_document.default.json
}
module "documentdb" {
  source = "../../"

  vpc_id      = module.vpc.vpc_id
  subnet_list = module.subnets.private_subnet_id

  database_name       = "rds"
  environment         = "test"
  label_order         = ["environment", "name"]
  skip_final_snapshot = false
  storage_encrypted   = true
  kms_key_id          = module.kms_key.key_arn
  tls_enabled         = true

  instance_class = "db.t3.medium"
  cluster_size   = 1
}