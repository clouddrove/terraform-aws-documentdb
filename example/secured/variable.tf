variable "skip_final_snapshot" {
    type = bool
    default = false
    description = ""
}

variable "storage_encrypted" {
    type = bool
    default = true
    description = ""
}

variable "tls_enabled" {
    type = bool
    default = true
    description = ""
}

variable "instance_class" {
    type = string
    default = "db.t3.medium"
    description = ""
}

variable "cluster_size" {
    type = number
    default = 1
    description = ""
}
