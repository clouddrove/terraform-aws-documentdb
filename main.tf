#Module      : Label
#Description : This terraform module is designed to generate consistent label names and tags
#              for resources. You can use terraform-labels to implement a strict naming
#              convention.
module "labels" {
  source      = "clouddrove/labels/aws"
  version     = "0.15.0"
  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
}

#Module      : DocumentDB
#Description : This terraform module is designed to create DocumentDB
resource "aws_security_group" "this" {
  name        = "security_group-allow_all_documentdb-${var.database_name}"
  description = "Allow inbound traffic"

  vpc_id = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_password" "master" {
  count   = length(var.master_password) == 0 ? 1 : 0
  length  = 15
  special = false
}
resource "aws_docdb_cluster" "this" {
  cluster_identifier              = var.database_name
  master_username                 = var.master_username
  master_password                 = length(var.master_password) == 0 ? random_password.master[0].result : var.master_password
  backup_retention_period         = var.retention_period
  preferred_backup_window         = var.preferred_backup_window
  final_snapshot_identifier       = lower(var.database_name)
  skip_final_snapshot             = var.skip_final_snapshot
  apply_immediately               = var.apply_immediately
  deletion_protection             = var.deletion_protection  
  storage_encrypted               = var.storage_encrypted
  kms_key_id                      = var.kms_key_id
  snapshot_identifier             = var.snapshot_identifier
  vpc_security_group_ids          = [aws_security_group.this.id]
  db_subnet_group_name            = aws_docdb_subnet_group.this.name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.this.name
  engine                          = var.engine
  engine_version                  = var.engine_version
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  tags                            = module.labels.tags
}

resource "aws_docdb_cluster_instance" "this" {
  count              = var.cluster_size
  identifier         = "${var.database_name}-${count.index + 1}"
  cluster_identifier = join("", aws_docdb_cluster.this.*.id)
  apply_immediately  = var.apply_immediately
  instance_class     = var.instance_class
  tags               = module.labels.tags
  engine             = var.engine
}

resource "aws_docdb_subnet_group" "this" {
  name        = "subnet-group-${var.database_name}"
  description = "Allowed subnets for DB cluster instances."
  subnet_ids  = var.subnet_list
  tags        = module.labels.tags
}

resource "aws_docdb_cluster_parameter_group" "this" {
  name        = "parameter-group-${var.database_name}"
  description = "DB cluster parameter group."
  family      = var.cluster_family
  parameter {
    name  = "tls"
    value = var.tls_enabled ? "enabled" : "disabled"
  }
  tags = module.labels.tags
}
