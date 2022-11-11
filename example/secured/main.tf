module "documentdb" {
  source = "../../"
  database_name       = "rds"
  environment         = "test"
  label_order         = ["environment", "name"]
  vpc_id              = module.vpc.vpc_id
  subnet_list         = module.subnets.private_subnet_id
  skip_final_snapshot = var.skip_final_snapshot
  storage_encrypted   = var.storage_encrypted
  kms_key_id          = module.kms_key.key_arn
  tls_enabled         = var.tls_enabled
  instance_class      = var.instance_class
  cluster_size        = var.cluster_size
}