
provider "aws" {
  region = "us-east-1"
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


module "kms_key" {
  source                  = "clouddrove/kms/aws"
  version                 = "1.3.0"
  name                    = "kms"
  environment             = "test"
  label_order             = ["environment", "name"]
  enabled                 = true
  description             = "KMS key for ec2"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  alias                   = "alias/ec3"
  policy                  = data.aws_iam_policy_document.kms.json
}


data "aws_iam_policy_document" "kms" {
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

}

data "aws_iam_policy_document" "default" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "iam-policy" {
  statement {
    actions = [
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
    "ssmmessages:OpenDataChannel"]
    effect    = "Allow"
    resources = ["*"]
  }
}

module "security_group-documentdb" {
  source  = "clouddrove/security-group/aws"
  version = "1.3.0"

  name          = "documentdb"
  environment   = "test"
  protocol      = "tcp"
  label_order   = ["environment", "name"]
  vpc_id        = module.vpc.vpc_id
  allowed_ip    = ["172.16.0.0/16"]
  allowed_ports = [27017]
}

module "documentdb" {
  source                  = "../../"
  name                    = "documentdb"
  environment             = "test"
  label_order             = ["environment", "name"]
  vpc_id                  = module.vpc.vpc_id
  subnet_list             = module.subnets.private_subnet_id
  vpc_security_group_ids  = [module.security_group-documentdb.security_group_ids]
  database_name           = "test"
  skip_final_snapshot     = false
  storage_encrypted       = true
  kms_key_id              = module.kms_key.key_arn
  tls_enabled             = true
  instance_class          = "db.t3.medium"
  cluster_size            = 3
  deletion_protection     = true
  preferred_backup_window = "07:00-07:30"
  
}