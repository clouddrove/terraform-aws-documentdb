##-----------------------------------------------------------------------------
## label Module.
##-----------------------------------------------------------------------------
module "labels" {
  source      = "clouddrove/labels/aws"
  version     = "1.3.0"
  enabled     = var.enable
  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
}

##-----------------------------------------------------------------------------
## Random password genrator
##-----------------------------------------------------------------------------

resource "random_password" "master" {
  count   = var.enable && length(var.master_password) == 0 ? 1 : 0
  length  = 15
  special = false
}

##-----------------------------------------------------------------------------
## AWS Document DB cluster parameter Group.
##-----------------------------------------------------------------------------

resource "aws_docdb_cluster_parameter_group" "this" {
  count       = var.enable ? 1 : 0
  name        = "parameter-group-${var.database_name}"
  description = "DB cluster parameter group."
  family      = var.cluster_family

  dynamic "parameter" {
    for_each = var.parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  tags = module.labels.tags
}

##-----------------------------------------------------------------------------
## AWS Document DB Cluster.
##-----------------------------------------------------------------------------

resource "aws_docdb_cluster" "this" {
  count                           = var.enable ? 1 : 0
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
  kms_key_id                      = var.kms_key_id #tfsec:ignore:aws-documentdb-encryption-customer-key
  snapshot_identifier             = var.snapshot_identifier
  vpc_security_group_ids          = var.vpc_security_group_ids
  db_subnet_group_name            = aws_docdb_subnet_group.this[0].name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.this[0].name
  engine                          = var.engine
  engine_version                  = var.engine_version
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  tags                            = module.labels.tags

  depends_on = [aws_docdb_cluster_parameter_group.this]
}

##-----------------------------------------------------------------------------
## AWS Document DB instance.
##-----------------------------------------------------------------------------

resource "aws_docdb_cluster_instance" "this" {
  count              = var.enable ? var.cluster_size : 0
  identifier         = "${var.database_name}-${count.index + 1}"
  cluster_identifier = aws_docdb_cluster.this[0].id
  apply_immediately  = var.apply_immediately
  instance_class     = var.instance_class
  tags               = module.labels.tags
  engine             = var.engine
  kms_key_id         = var.kms_key_id
  ca_cert_identifier = var.ca_cert_identifier
}

##-----------------------------------------------------------------------------
## AWS Document DB Subnet Group.
##-----------------------------------------------------------------------------

resource "aws_docdb_subnet_group" "this" {
  count       = var.enable ? 1 : 0
  name        = "subnet-group-${var.database_name}"
  description = "Allowed subnets for DB cluster instances."
  subnet_ids  = var.subnet_list
  tags        = module.labels.tags
}