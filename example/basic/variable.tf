variable "master_password" {
    type = string
    default = "test123456"
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