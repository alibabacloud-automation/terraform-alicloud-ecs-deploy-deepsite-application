output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.ecs_deploy_deepsite.vpc_id
}

output "vswitch_id" {
  description = "The ID of the VSwitch"
  value       = module.ecs_deploy_deepsite.vswitch_id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.ecs_deploy_deepsite.security_group_id
}

output "security_group_rules" {
  description = "The IDs of the security group rules"
  value       = module.ecs_deploy_deepsite.security_group_rules
}

output "instance_id" {
  description = "The ID of the ECS instance"
  value       = module.ecs_deploy_deepsite.instance_id
}

output "instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = module.ecs_deploy_deepsite.instance_public_ip
}

output "deepsite_access_url" {
  description = "The URL to access the DeepSite application"
  value       = module.ecs_deploy_deepsite.deepsite_access_url
}

output "ecs_login_url" {
  description = "The ECS console login URL for the instance"
  value       = module.ecs_deploy_deepsite.ecs_login_url
}

