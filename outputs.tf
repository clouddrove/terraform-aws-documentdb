output "master_username" {
  value       = try(aws_docdb_cluster.this[0].master_username, null)
  description = "Username for the master DB user."
  sensitive   = true
}

output "master_password" {
  value       = length(var.master_password) == 0 ? random_password.master[0].result : var.master_password
  description = "password for the master DB user."
  sensitive   = true
}

output "cluster_name" {
  value       = try(aws_docdb_cluster.this[0].cluster_identifier, null)
  description = "Cluster Identifier."
}

output "arn" {
  value       = try(aws_docdb_cluster.this[0].arn, null)
  description = "Amazon Resource Name (ARN) of the cluster."
}

output "writer_endpoint" {
  value       = try(aws_docdb_cluster.this[0].endpoint, null)
  description = "Endpoint of the DocumentDB cluster."
}

output "reader_endpoint" {
  value       = try(aws_docdb_cluster.this[0].reader_endpoint, null)
  description = "A read-only endpoint of the DocumentDB cluster, automatically load-balanced across replicas."
}