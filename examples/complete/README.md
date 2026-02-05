# Complete Example

This example demonstrates how to use the `ecs-deploy-deepsite-application` module to create an ECS instance on Alibaba Cloud and deploy the DeepSite application.

## Usage

1. Configure your Alibaba Cloud credentials
2. Set the required variables (especially `instance_password`)
3. Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

## Required Variables

- `instance_password`: The password for the ECS instance (8-30 characters, must contain uppercase letters, lowercase letters, and numbers)

## Optional Variables

- `region`: The Alibaba Cloud region (default: "cn-hangzhou")
- `common_name`: Common name prefix for resources (default: "deepsite-example")
- `vpc_cidr_block`: CIDR block for VPC (default: "192.168.0.0/16")
- `vswitch_cidr_block`: CIDR block for VSwitch (default: "192.168.0.0/24")
- `security_group_cidr_ip`: CIDR IP for security group rules (default: "0.0.0.0/0")

## Outputs

- `deepsite_access_url`: The URL to access the DeepSite application
- `instance_public_ip`: The public IP address of the ECS instance
- `ecs_login_url`: The ECS console login URL

## Notes

- The DeepSite application will be accessible on port 8080 after deployment
- The security group allows access from the specified CIDR IP range
- The installation script will be executed automatically after instance creation
- Allow some time for the application to fully install and start