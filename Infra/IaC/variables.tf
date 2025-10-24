variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_cidr_block1" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_cidr_block2" {
  type    = string
  default = "10.0.2.0/24"
}

variable "public_cidr_block3" {
  type    = string
  default = "10.0.3.0/24"
}

variable "private_cidr_block1" {
  type    = string
  default = "10.0.4.0/24"
}

variable "private_cidr_block2" {
  type    = string
  default = "10.0.5.0/24"
}

variable "private_cidr_block3" {
  type    = string
  default = "10.0.6.0/24"
}

variable "eks_cluster_version" {
  type = string
}

variable "node_group_instance_types" {
  type    = string
  default = "t3.medium"
}

variable "stack_name" {
  type    = string
  default = "eks-cluster"
  description = "Name to be used on all resources as prefix"
}

variable "region" {
  type    = string
  default = "us-west-2"
  description = "AWS region"
}
