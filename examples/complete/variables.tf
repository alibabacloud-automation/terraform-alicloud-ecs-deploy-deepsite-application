variable "region" {
  type        = string
  description = "The Alibaba Cloud region where resources will be created"
  default     = "cn-zhangjiakou"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "192.168.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = null
}

variable "vswitch_cidr_block" {
  type        = string
  description = "CIDR block for the VSwitch"
  default     = "192.168.0.0/24"
}

variable "vswitch_name" {
  type        = string
  description = "Name of the VSwitch"
  default     = null
}

variable "security_group_name" {
  type        = string
  description = "Name of the security group"
  default     = null
}

variable "security_group_cidr_ip" {
  type        = string
  description = "CIDR IP for security group rules"
  default     = "192.168.0.0/16"
}

variable "instance_name" {
  type        = string
  description = "Name of the ECS instance"
  default     = null
}

variable "ecs_instance_password" {
  type        = string
  description = "Password for the ECS instance"
  sensitive   = true
}

