# Complete Example

This example demonstrates how to use the MSE Traffic Protection module to deploy a complete infrastructure for implementing comprehensive traffic protection using Microservices Engine (MSE).

## What This Example Does

This example creates:

- A VPC with a custom CIDR block
- A VSwitch in an available zone
- A security group with rules to allow HTTP traffic
- An ECS instance with MSE traffic protection application deployed
- ECS command and invocation for automatic deployment

## Prerequisites

1. **MSE License Key**: You need to obtain an MSE License Key from the Alibaba Cloud console
   - Login to MSE console: https://mse.console.aliyun.com
   - Click Governance Center > Application Governance
   - Select the region at the top
   - Click "View License Key" in the upper right corner

2. **Alibaba Cloud Account**: Ensure you have proper permissions to create VPC, ECS, and other resources

## Usage

To run this example, you need to execute:

```bash
terraform init
terraform plan
terraform apply
```

Note that this example creates real resources which will incur costs. Run `terraform destroy` when you no longer need these resources.

## Required Variables

Create a `terraform.tfvars` file with the following content:

```hcl
# Required: MSE License Key
mse_license_key = "your-mse-license-key-here"

# Required: ECS instance password
ecs_instance_password = "YourSecurePassword123!"

# Optional: Customize region and instance type
region = "cn-hangzhou"
instance_type = "ecs.t6-c1m2.large"
```

## Outputs

After successful deployment, you will get:

- `ecs_login_address`: Direct link to login to the ECS instance via web console
- `demo_url`: URL to access the deployed application
- `vpc_id`: The ID of the created VPC
- `ecs_instance_id`: The ID of the created ECS instance
- Various other resource IDs for reference

## Notes

- The ECS instance will automatically install and configure the MSE traffic protection application
- The deployment process may take 10-15 minutes to complete
- Ensure your MSE License Key is valid for the selected region
- The security group is configured to allow HTTP traffic on port 80 from the VPC CIDR range

## Cost

This example will create resources that cost money. Run `terraform destroy` when you no longer need these resources.

## Cleanup

To destroy the resources created by this example:

```bash
terraform destroy
```