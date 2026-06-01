
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "2.0.4"

  name        = "vpc"
  environment = "test"
  label_order = ["name", "environment"]

  cidr_block = "172.16.0.0/16"
}

module "subnets" {
  source  = "clouddrove/subnet/aws"
  version = "2.0.3"

  name        = "subnets"
  environment = "test"
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


module "kms_key" {
  source                  = "clouddrove/kms/aws"
  version                 = "1.3.2"
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

module "security_group-documentdb" {
  source  = "clouddrove/security-group/aws"
  version = "2.0.3"

  name        = "documentdb"
  environment = "test"
  label_order = ["environment", "name"]
  vpc_id      = module.vpc.vpc_id

  ## INGRESS Rules
  new_sg_ingress_rules_with_cidr_blocks = [{
    rule_count  = 1
    from_port   = 27017
    protocol    = "tcp"
    to_port     = 27017
    cidr_blocks = ["172.16.0.0/16"]
    description = "Allow DocumentDB traffic."
  }]

  ## EGRESS Rules
  new_sg_egress_rules_with_cidr_blocks = [{
    rule_count  = 1
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic."
  }]
}

module "documentdb" {
  source                  = "../../"
  enable                  = true
  name                    = "documentdb"
  environment             = "test"
  label_order             = ["environment", "name"]
  subnet_list             = module.subnets.private_subnet_id
  vpc_security_group_ids  = [module.security_group-documentdb.security_group_ids]
  database_name           = "test"
  skip_final_snapshot     = var.skip_final_snapshot
  storage_encrypted       = var.storage_encrypted
  kms_key_id              = module.kms_key.key_arn
  instance_class          = var.instance_class
  cluster_family          = "docdb5.0"
  cluster_size            = var.cluster_size
  deletion_protection     = true
  preferred_backup_window = "07:00-07:30"
  ca_cert_identifier      = "rds-ca-rsa2048-g1"
  parameters = [
    {
      apply_method = "immediate"
      name         = "tls"
      value        = "enabled"
    }
  ]
}
