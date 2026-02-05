
locals {
  # DeepSite installation script content
  default_script_template = base64encode(<<EOF
#!/bin/bash
# Execute DeepSite installation script
curl -fsSL https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/zh-CN/20251217/rilwsn/install.sh|bash
EOF
  )
}

# VPC resource
resource "alicloud_vpc" "vpc" {
  cidr_block = var.vpc_config.cidr_block
  vpc_name   = var.vpc_config.vpc_name
}

# VSwitch resource
resource "alicloud_vswitch" "vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.vswitch_config.cidr_block
  zone_id      = var.vswitch_config.zone_id
  vswitch_name = var.vswitch_config.vswitch_name
}

# Security group resource
resource "alicloud_security_group" "security_group" {
  vpc_id              = alicloud_vpc.vpc.id
  security_group_name = var.security_group_config.security_group_name
  description         = var.security_group_config.description
}

# Security group rules using for_each to reduce code duplication
resource "alicloud_security_group_rule" "ingress_rules" {
  for_each = {
    for i, rule in var.security_group_rules_config.rules : "${rule.port_range}-${rule.protocol}" => rule
  }

  type              = each.value.type
  ip_protocol       = each.value.protocol
  nic_type          = each.value.nic_type
  policy            = each.value.policy
  port_range        = each.value.port_range
  priority          = each.value.priority
  security_group_id = alicloud_security_group.security_group.id
  cidr_ip           = each.value.cidr_ip
  description       = each.value.description
}

# ECS instance resource
resource "alicloud_instance" "ecs_instance" {
  instance_name              = var.instance_config.instance_name
  system_disk_category       = var.instance_config.system_disk_category
  image_id                   = var.instance_config.image_id
  vswitch_id                 = alicloud_vswitch.vswitch.id
  password                   = var.instance_config.password
  instance_type              = var.instance_config.instance_type
  internet_max_bandwidth_out = var.instance_config.internet_max_bandwidth_out
  security_groups            = [alicloud_security_group.security_group.id]
}


# ECS command resource for DeepSite application installation script
resource "alicloud_ecs_command" "install_app" {
  name            = var.ecs_command_config.name
  command_content = var.custom_script != null ? base64encode(var.custom_script) : local.default_script_template
  working_dir     = var.ecs_command_config.working_dir
  type            = var.ecs_command_config.type
  timeout         = var.ecs_command_config.timeout
}

# ECS invocation resource to execute the installation command
resource "alicloud_ecs_invocation" "invoke_script" {
  instance_id = [alicloud_instance.ecs_instance.id]
  command_id  = alicloud_ecs_command.install_app.id

  timeouts {
    create = var.ecs_invocation_config.timeout_create
  }
}