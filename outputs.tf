output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.vpc.id
}

output "vswitch_id" {
  description = "The ID of the VSwitch"
  value       = alicloud_vswitch.vswitch.id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.security_group.id
}

output "security_group_rules" {
  description = "The IDs of the security group rules"
  value       = { for k, v in alicloud_security_group_rule.ingress_rules : k => v.id }
}

output "instance_id" {
  description = "The ID of the ECS instance"
  value       = alicloud_instance.ecs_instance.id
}

output "instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = alicloud_instance.ecs_instance.public_ip
}


output "ecs_command_id" {
  description = "The ID of the ECS command for DeepSite installation"
  value       = alicloud_ecs_command.install_app.id
}

output "ecs_invocation_id" {
  description = "The ID of the ECS command invocation"
  value       = alicloud_ecs_invocation.invoke_script.id
}

output "deepsite_access_url" {
  description = "The URL to access the DeepSite application"
  value       = "http://${alicloud_instance.ecs_instance.public_ip}:8080"
}

output "ecs_login_url" {
  description = "The ECS console login URL for the instance"
  value       = "https://ecs.console.aliyun.com/#/server/${alicloud_instance.ecs_instance.id}/detail"
}