
variable "vpc_config" {
  type = object({
    cidr_block = string
    vpc_name   = optional(string, null)
  })
  description = "Configuration for the VPC. The 'cidr_block' attribute is required."
}

variable "vswitch_config" {
  type = object({
    cidr_block   = string
    zone_id      = string
    vswitch_name = optional(string, null)
  })
  description = "Configuration for the VSwitch. The 'cidr_block' and 'zone_id' attributes are required."

}

variable "security_group_config" {
  type = object({
    security_group_name = optional(string, null)
    description         = optional(string, "Security group for DeepSite application")
  })
  description = "Configuration for the security group."

}

variable "security_group_rules_config" {
  type = object({
    rules = list(object({
      port_range  = string
      protocol    = optional(string, "tcp")
      priority    = optional(number, 1)
      cidr_ip     = optional(string, "0.0.0.0/0")
      description = optional(string, "")
      type        = optional(string, "ingress")
      nic_type    = optional(string, "intranet")
      policy      = optional(string, "accept")
    }))
  })
  description = "Configuration for security group rules. Uses a list structure to define multiple rules efficiently."
  default = {
    rules = [
      {
        port_range  = "8080/8080"
        protocol    = "tcp"
        priority    = 1
        cidr_ip     = "0.0.0.0/0"
        description = "HTTP access"
        type        = "ingress"
        nic_type    = "intranet"
        policy      = "accept"
      },
      {
        port_range  = "80/80"
        protocol    = "tcp"
        priority    = 1
        cidr_ip     = "0.0.0.0/0"
        description = "HTTP access"
        type        = "ingress"
        nic_type    = "intranet"
        policy      = "accept"
      },
      {
        port_range  = "443/443"
        protocol    = "tcp"
        priority    = 1
        cidr_ip     = "0.0.0.0/0"
        description = "HTTPS access"
        type        = "ingress"
        nic_type    = "intranet"
        policy      = "accept"
      }
    ]
  }
}

variable "instance_config" {
  type = object({
    instance_name              = optional(string, null)
    system_disk_category       = optional(string, "cloud_essd")
    image_id                   = string
    password                   = string
    instance_type              = string
    internet_max_bandwidth_out = optional(number, 5)
  })
  description = "Configuration for the ECS instance. The 'image_id', 'password', and 'instance_type' attributes are required."
  default = {
    system_disk_category       = "cloud_essd"
    image_id                   = null
    password                   = null
    instance_type              = null
    internet_max_bandwidth_out = 5
  }
}


variable "ecs_command_config" {
  type = object({
    name            = optional(string, "install-deepsite-app")
    command_content = optional(string)
    working_dir     = optional(string, "/root")
    type            = optional(string, "RunShellScript")
    timeout         = optional(number, 3600)
  })
  description = "Configuration for the ECS command to install DeepSite application."
  default = {
    name            = "install-deepsite-app"
    command_content = null # Will use local.default_script_template as default
    working_dir     = "/root"
    type            = "RunShellScript"
    timeout         = 3600
  }
}

variable "ecs_invocation_config" {
  type = object({
    timeout_create = optional(string, "15m")
  })
  description = "Configuration for the ECS command invocation."
  default = {
    timeout_create = "15m"
  }
}

variable "custom_script" {
  type        = string
  default     = null
  description = "Optional custom script to override the default DeepSite installation script"
}