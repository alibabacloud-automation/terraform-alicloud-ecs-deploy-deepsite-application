Alibaba Cloud ECS DeepSite Application Deployment Terraform Module

================================================

# terraform-alicloud-ecs-deploy-deepsite-application

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-ecs-deploy-deepsite-application/blob/main/README-CN.md)

Terraform module which creates an ECS instance on Alibaba Cloud and automatically deploys the DeepSite application. This module sets up the complete infrastructure including VPC, VSwitch, Security Group, and ECS instance with automated DeepSite application installation.

[DeepSite](https://www.aliyun.com/solution/tech-solution/deepsite/2938367) is an AI-powered front-end code generation tool that can generate web applications from natural language descriptions, primarily used for web tool development and product prototyping. The solution offers a complete workflow for deploying DeepSite applications on Alibaba Cloud ECS (Elastic Compute Service) instances, featuring natural language-to-web conversion, real-time preview with responsive design, AI-driven code generation, one-click export capabilities, powerful AI code generation without programming basics, multi-round optimization through natural language conversations, and support for multiple large language models including Qwen and DeepSeek.

## Usage

This module creates a complete infrastructure setup for deploying the DeepSite application on Alibaba Cloud ECS. It includes network configuration, security settings, and automated application deployment.

```terraform
data "alicloud_zones" "available" {
  available_resource_creation = "VSwitch"
}

data "alicloud_instance_types" "available" {
  availability_zone = data.alicloud_zones.available.zones[0].id
  cpu_core_count    = 2
  memory_size       = 4
}

data "alicloud_images" "available" {
  name_regex  = "^ubuntu_20.*64"
  most_recent = true
  owners      = "system"
}

module "ecs_deploy_deepsite" {
  source = "alibabacloud-automation/ecs-deploy-deepsite-application/alicloud"

  vpc_config = {
    cidr_block = "192.168.0.0/16"
    vpc_name   = "deepsite-vpc"
  }

  vswitch_config = {
    cidr_block   = "192.168.0.0/24"
    zone_id      = data.alicloud_zones.available.zones[0].id
    vswitch_name = "deepsite-vswitch"
  }

  security_group_config = {
    security_group_name = "deepsite-security-group"
    description         = "Security group for DeepSite application"
  }

  security_group_rules_config = {
    rules = [
      {
        port_range  = "8080/8080"
        protocol    = "tcp"
        priority    = 1
        cidr_ip     = "0.0.0.0/0"
        description = "DeepSite application access"
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

  instance_config = {
    instance_name              = "deepsite-instance"
    image_id                   = data.alicloud_images.available.images[0].id
    instance_type              = data.alicloud_instance_types.available.instance_types[0].id
    password                   = "YourPassword123!"
    system_disk_category       = "cloud_essd"
    internet_max_bandwidth_out = 5
  }

  ecs_command_config = {
    name        = "install-deepsite-app"
    working_dir = "/root"
    type        = "RunShellScript"
    timeout     = 3600
  }

  ecs_invocation_config = {
    timeout_create = "15m"
  }
}
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-ecs-deploy-deepsite-application/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.212.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.212.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_ecs_command.install_app](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_command) | resource |
| [alicloud_ecs_invocation.invoke_script](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_invocation) | resource |
| [alicloud_instance.ecs_instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/instance) | resource |
| [alicloud_security_group.security_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group) | resource |
| [alicloud_security_group_rule.ingress_rules](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group_rule) | resource |
| [alicloud_vpc.vpc](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.vswitch](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_script"></a> [custom\_script](#input\_custom\_script) | Optional custom script to override the default DeepSite installation script | `string` | `null` | no |
| <a name="input_ecs_command_config"></a> [ecs\_command\_config](#input\_ecs\_command\_config) | Configuration for the ECS command to install DeepSite application. | <pre>object({<br/>    name            = optional(string, "install-deepsite-app")<br/>    command_content = optional(string)<br/>    working_dir     = optional(string, "/root")<br/>    type            = optional(string, "RunShellScript")<br/>    timeout         = optional(number, 3600)<br/>  })</pre> | <pre>{<br/>  "command_content": null,<br/>  "name": "install-deepsite-app",<br/>  "timeout": 3600,<br/>  "type": "RunShellScript",<br/>  "working_dir": "/root"<br/>}</pre> | no |
| <a name="input_ecs_invocation_config"></a> [ecs\_invocation\_config](#input\_ecs\_invocation\_config) | Configuration for the ECS command invocation. | <pre>object({<br/>    timeout_create = optional(string, "15m")<br/>  })</pre> | <pre>{<br/>  "timeout_create": "15m"<br/>}</pre> | no |
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | Configuration for the ECS instance. The 'image\_id', 'password', and 'instance\_type' attributes are required. | <pre>object({<br/>    instance_name              = optional(string, null)<br/>    system_disk_category       = optional(string, "cloud_essd")<br/>    image_id                   = string<br/>    password                   = string<br/>    instance_type              = string<br/>    internet_max_bandwidth_out = optional(number, 5)<br/>  })</pre> | <pre>{<br/>  "image_id": null,<br/>  "instance_type": null,<br/>  "internet_max_bandwidth_out": 5,<br/>  "password": null,<br/>  "system_disk_category": "cloud_essd"<br/>}</pre> | no |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | Configuration for the security group. | <pre>object({<br/>    security_group_name = optional(string, null)<br/>    description         = optional(string, "Security group for DeepSite application")<br/>  })</pre> | n/a | yes |
| <a name="input_security_group_rules_config"></a> [security\_group\_rules\_config](#input\_security\_group\_rules\_config) | Configuration for security group rules. Uses a list structure to define multiple rules efficiently. | <pre>object({<br/>    rules = list(object({<br/>      port_range  = string<br/>      protocol    = optional(string, "tcp")<br/>      priority    = optional(number, 1)<br/>      cidr_ip     = optional(string, "0.0.0.0/0")<br/>      description = optional(string, "")<br/>      type        = optional(string, "ingress")<br/>      nic_type    = optional(string, "intranet")<br/>      policy      = optional(string, "accept")<br/>    }))<br/>  })</pre> | <pre>{<br/>  "rules": [<br/>    {<br/>      "cidr_ip": "0.0.0.0/0",<br/>      "description": "HTTP access",<br/>      "nic_type": "intranet",<br/>      "policy": "accept",<br/>      "port_range": "8080/8080",<br/>      "priority": 1,<br/>      "protocol": "tcp",<br/>      "type": "ingress"<br/>    },<br/>    {<br/>      "cidr_ip": "0.0.0.0/0",<br/>      "description": "HTTP access",<br/>      "nic_type": "intranet",<br/>      "policy": "accept",<br/>      "port_range": "80/80",<br/>      "priority": 1,<br/>      "protocol": "tcp",<br/>      "type": "ingress"<br/>    },<br/>    {<br/>      "cidr_ip": "0.0.0.0/0",<br/>      "description": "HTTPS access",<br/>      "nic_type": "intranet",<br/>      "policy": "accept",<br/>      "port_range": "443/443",<br/>      "priority": 1,<br/>      "protocol": "tcp",<br/>      "type": "ingress"<br/>    }<br/>  ]<br/>}</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for the VPC. The 'cidr\_block' attribute is required. | <pre>object({<br/>    cidr_block = string<br/>    vpc_name   = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_vswitch_config"></a> [vswitch\_config](#input\_vswitch\_config) | Configuration for the VSwitch. The 'cidr\_block' and 'zone\_id' attributes are required. | <pre>object({<br/>    cidr_block   = string<br/>    zone_id      = string<br/>    vswitch_name = optional(string, null)<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deepsite_access_url"></a> [deepsite\_access\_url](#output\_deepsite\_access\_url) | The URL to access the DeepSite application |
| <a name="output_ecs_command_id"></a> [ecs\_command\_id](#output\_ecs\_command\_id) | The ID of the ECS command for DeepSite installation |
| <a name="output_ecs_invocation_id"></a> [ecs\_invocation\_id](#output\_ecs\_invocation\_id) | The ID of the ECS command invocation |
| <a name="output_ecs_login_url"></a> [ecs\_login\_url](#output\_ecs\_login\_url) | The ECS console login URL for the instance |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The ID of the ECS instance |
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | The public IP address of the ECS instance |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_security_group_rules"></a> [security\_group\_rules](#output\_security\_group\_rules) | The IDs of the security group rules |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vswitch_id"></a> [vswitch\_id](#output\_vswitch\_id) | The ID of the VSwitch |
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)