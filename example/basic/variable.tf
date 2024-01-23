variable "master_password" {
  type        = string
  default     = "QfbaJpP00W0m413Bw1fe"
  description = "Master password for documentDB."
}

variable "instance_class" {
  type        = string
  default     = "db.t3.medium"
  description = "Instance class for DocumentDB Cluster."
}

variable "cluster_size" {
  type        = number
  default     = 1
  description = "cluster size of DocumentDB."
}