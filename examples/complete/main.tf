# Configure the Alicloud Provider
provider "alicloud" {
  region = var.region
}

# Get available zones
data "alicloud_zones" "available" {
  available_resource_creation = "VSwitch"
}

# Get available instance types
data "alicloud_instance_types" "available" {
  availability_zone    = data.alicloud_zones.available.zones[0].id
  cpu_core_count       = 2
  memory_size          = 8
  instance_type_family = "ecs.g9i"
}

# Get available images
data "alicloud_images" "available" {
  name_regex  = "^aliyun_3_x64*"
  most_recent = true
  owners      = "system"
}

# Call the module
module "ecs_deploy_deepsite" {
  source = "../../"

  vpc_config = {
    cidr_block = var.vpc_cidr_block
    vpc_name   = var.vpc_name
  }

  vswitch_config = {
    cidr_block   = var.vswitch_cidr_block
    zone_id      = data.alicloud_zones.available.zones[0].id
    vswitch_name = var.vswitch_name
  }

  security_group_config = {
    security_group_name = var.security_group_name
    description         = "Security group for DeepSite application example"
  }

  security_group_rules_config = {
    rules = [
      {
        port_range  = "8080/8080"
        description = "DeepSite application access"
        type        = "ingress"
        nic_type    = "intranet"
        policy      = "accept"
        cidr_ip     = var.security_group_cidr_ip
      },
      {
        port_range  = "80/80"
        protocol    = "tcp"
        priority    = 1
        cidr_ip     = var.security_group_cidr_ip
        description = "HTTP access"
        type        = "ingress"
        nic_type    = "intranet"
        policy      = "accept"
      },
      {
        port_range  = "443/443"
        protocol    = "tcp"
        priority    = 1
        cidr_ip     = var.security_group_cidr_ip
        description = "HTTPS access"
        type        = "ingress"
        nic_type    = "intranet"
        policy      = "accept"
      }
    ]
  }

  instance_config = {
    instance_name              = var.instance_name
    system_disk_category       = "cloud_essd"
    image_id                   = data.alicloud_images.available.images[0].id
    password                   = var.ecs_instance_password
    instance_type              = data.alicloud_instance_types.available.instance_types[0].id
    internet_max_bandwidth_out = 5
  }

  ecs_command_config = {
    name            = "install-deepsite-app"
    command_content = null # Will use the default script from local variables
    working_dir     = "/root"
    type            = "RunShellScript"
    timeout         = 3600
  }

  ecs_invocation_config = {
    timeout_create = "15m"
  }
}