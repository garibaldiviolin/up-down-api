variable "access_key" {}
variable "secret_key" {}

variable "region" {}

variable "amis" {
  type = "map"
}

variable "autoscaling_group_min_size" {}
variable "autoscaling_group_max_size" {}
variable "instance_type" {}
variable "public_key_path" {}
variable "rds_instance_identifier" {}
variable "database_name" {}
variable "database_password" {}
variable "database_user" {}

variable "allowed_cidr_blocks" {
  type = "list"
}
