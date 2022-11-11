
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