阿里云 ECS DeepSite 应用部署 Terraform 模块

================================================ 

# terraform-alicloud-ecs-deploy-deepsite-application

[English](https://github.com/terraform-alicloud-modules/terraform-alicloud-ecs-deploy-deepsite-application/blob/master/README.md) | 简体中文

在阿里云上创建 ECS 实例并自动部署 DeepSite 应用的 Terraform 模块。此模块设置完整的基础设施，包括 VPC、VSwitch、安全组和 ECS 实例，并自动安装 DeepSite 应用。

## 使用方法

此模块为在阿里云 ECS 上部署 DeepSite 应用创建完整的基础设施设置。包括网络配置、安全设置和自动应用部署。

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

  common_name = "my-deepsite-app"

  vpc_config = {
    cidr_block = "192.168.0.0/16"
    vpc_name   = "deepsite-vpc"
  }

  vswitch_config = {
    cidr_block   = "192.168.0.0/24"
    zone_id      = data.alicloud_zones.available.zones[0].id
    vswitch_name = "deepsite-vswitch"
  }

  instance_config = {
    instance_name              = "deepsite-instance"
    image_id                   = data.alicloud_images.available.images[0].id
    instance_type              = data.alicloud_instance_types.available.instance_types[0].id
    password                   = "YourPassword123!"
    system_disk_category       = "cloud_essd"
    internet_max_bandwidth_out = 5
  }

  security_group_rules_config = {
    rules = {
      deepsite = {
        port_range  = "8080/8080"
        description = "DeepSite 应用访问"
      }
      http = {
        port_range  = "80/80"
        description = "HTTP 访问"
      }
      https = {
        port_range  = "443/443"
        description = "HTTPS 访问"
      }
    }
    default_cidr_ip = "0.0.0.0/0"  # 允许来自任何地方的访问
  }
}
```

## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-ecs-deploy-deepsite-application/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## 版本要求

| Name | Version |
|------|------------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.212.0 |

## Providers

| Name | Version |
|------|------------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.212.0 |

## 模块

无模块。

## 资源

| Name | Type |
|------|------|
| [alicloud_ecs_command.install_app](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_command) | resource |
| [alicloud_ecs_invocation.invoke_script](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_invocation) | resource |
| [alicloud_instance.ecs_instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/instance) | resource |
| [alicloud_ram_user.user](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_user) | resource |
| [alicloud_security_group.security_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group) | resource |
| [alicloud_security_group_rule.ingress_rules](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group_rule) | resource |
| [alicloud_vpc.vpc](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.vswitch](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |

## 输入变量

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_name"></a> [common\_name](#input\_common\_name) | 所有资源的通用名称前缀。如果未提供，将生成基于时间戳的名称。 | `string` | `null` | no |
| <a name="input_ecs_command_config"></a> [ecs\_command\_config](#input\_ecs\_command\_config) | ECS 命令配置，用于安装 DeepSite 应用。 | <pre>object({<br>    name            = optional(string, "install-deepsite-app")<br>    command_content = optional(string)<br>    working_dir     = optional(string, "/root")<br>    type            = optional(string, "RunShellScript")<br>    timeout         = optional(number, 3600)<br>  })</pre> | <pre>{<br>  "command_content": "IyEvYmluL2Jhc2gKIyBFeGVjdXRlIERlZXBTaXRlIGluc3RhbGxhdGlvbiBzY3JpcHQKY3VybCAtZnNTTCBodHRwczovL2hlbHAtc3RhdGljLWFsaXl1bi1kb2MuYWxpeXVuY3MuY29tL2ZpbGUtbWFuYWdlLWZpbGVzL3poLUNOLzIwMjUxMjE3L3JpbHdzbi9pbnN0YWxsLnNofGJhc2gK",<br>  "name": "install-deepsite-app",<br>  "timeout": 3600,<br>  "type": "RunShellScript",<br>  "working_dir": "/root"<br>}</pre> | no |
| <a name="input_ecs_invocation_config"></a> [ecs\_invocation\_config](#input\_ecs\_invocation\_config) | ECS 命令调用配置。 | <pre>object({<br>    timeout_create = optional(string, "15m")<br>  })</pre> | <pre>{<br>  "timeout_create": "15m"<br>}</pre> | no |
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | ECS 实例配置。'image\_id'、'password' 和 'instance\_type' 属性是必需的。 | <pre>object({<br>    instance_name              = optional(string, null)<br>    system_disk_category       = optional(string, "cloud_essd")<br>    image_id                   = string<br>    password                   = string<br>    instance_type              = string<br>    internet_max_bandwidth_out = optional(number, 5)<br>  })</pre> | <pre>{<br>  "image_id": null,<br>  "instance_type": null,<br>  "internet_max_bandwidth_out": 5,<br>  "password": null,<br>  "system_disk_category": "cloud_essd"<br>}</pre> | no |
| <a name="input_ram_user_config"></a> [ram\_user\_config](#input\_ram\_user\_config) | RAM 用户配置。如果未提供名称，将生成默认名称。 | <pre>object({<br>    name = optional(string, null)<br>  })</pre> | `{}` | no |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | 安全组配置。 | <pre>object({<br>    security_group_name = optional(string, null)<br>    description         = optional(string, "Security group for DeepSite application")<br>  })</pre> | <pre>{<br>  "description": "Security group for DeepSite application"<br>}</pre> | no |
| <a name="input_security_group_rules_config"></a> [security\_group\_rules\_config](#input\_security\_group\_rules\_config) | 安全组规则配置。使用映射结构有效地定义多个规则。 | <pre>object({<br>    rules = optional(map(object({<br>      port_range = string<br>      protocol   = optional(string, "tcp")<br>      priority   = optional(number, 1)<br>      cidr_ip    = optional(string, "192.168.0.0/24")<br>      description = optional(string, null)<br>    })), {<br>      deepsite = {<br>        port_range  = "8080/8080"<br>        description = "DeepSite application access"<br>      }<br>      http = {<br>        port_range  = "80/80"<br>        description = "HTTP access"<br>      }<br>      https = {<br>        port_range  = "443/443"<br>        description = "HTTPS access"<br>      }<br>    })<br>    default_priority = optional(number, 1)<br>    default_cidr_ip  = optional(string, "192.168.0.0/24")<br>  })</pre> | <pre>{<br>  "default_cidr_ip": "192.168.0.0/24",<br>  "default_priority": 1,<br>  "rules": {<br>    "deepsite": {<br>      "description": "DeepSite application access",<br>      "port_range": "8080/8080"<br>    },<br>    "http": {<br>      "description": "HTTP access",<br>      "port_range": "80/80"<br>    },<br>    "https": {<br>      "description": "HTTPS access",<br>      "port_range": "443/443"<br>    }<br>  }<br>}</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | VPC 配置。'cidr\_block' 属性是必需的。 | <pre>object({<br>    cidr_block = string<br>    vpc_name   = optional(string, null)<br>  })</pre> | <pre>{<br>  "cidr_block": "192.168.0.0/16"<br>}</pre> | no |
| <a name="input_vswitch_config"></a> [vswitch\_config](#input\_vswitch\_config) | VSwitch 配置。'cidr\_block' 和 'zone\_id' 属性是必需的。 | <pre>object({<br>    cidr_block   = string<br>    zone_id      = string<br>    vswitch_name = optional(string, null)<br>  })</pre> | <pre>{<br>  "cidr_block": "192.168.0.0/24",<br>  "zone_id": null<br>}</pre> | no |

## 输出

| Name | Description |
|------|-------------|
| <a name="output_deepsite_access_url"></a> [deepsite\_access\_url](#output\_deepsite\_access\_url) | 访问 DeepSite 应用的 URL |
| <a name="output_ecs_command_id"></a> [ecs\_command\_id](#output\_ecs\_command\_id) | DeepSite 安装 ECS 命令的 ID |
| <a name="output_ecs_invocation_id"></a> [ecs\_invocation\_id](#output\_ecs\_invocation\_id) | ECS 命令调用的 ID |
| <a name="output_ecs_login_url"></a> [ecs\_login\_url](#output\_ecs\_login\_url) | ECS 实例的控制台登录 URL |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | ECS 实例的 ID |
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | ECS 实例的公网 IP 地址 |
| <a name="output_ram_user_name"></a> [ram\_user\_name](#output\_ram\_user\_name) | RAM 用户的名称 |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | 安全组的 ID |
| <a name="output_security_group_rules"></a> [security\_group\_rules](#output\_security\_group\_rules) | 安全组规则的 ID |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC 的 ID |
| <a name="output_vswitch_id"></a> [vswitch\_id](#output\_vswitch\_id) | VSwitch 的 ID |
<!-- END_TF_DOCS -->

## 提交问题

如果您在使用此模块时遇到任何问题，请提交一个 [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) 并告知我们。

**注意：** 不建议在此仓库中提交问题。

## 作者

由阿里云 Terraform 团队创建和维护(terraform@alibabacloud.com)。

## 许可证

MIT 许可。有关完整详细信息，请参阅 LICENSE。

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)