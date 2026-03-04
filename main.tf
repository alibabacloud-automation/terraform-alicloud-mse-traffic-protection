# ------------------------------------------------------------------------------
# Core Resource Definitions
#
# This file contains the core infrastructure resources for the module.
# The code is responsible for creating and configuring all cloud resources
# based on input variables.
# ------------------------------------------------------------------------------

# Query current deployment region
data "alicloud_regions" "current" {
  current = true
}

# Define local variables for scripts
locals {
  # Default ECS command script for MSE traffic protection deployment
  default_ecs_command_script = base64encode(<<-EOF
cat << EOT >> ~/.bash_profile
export LICENSE_KEY=${var.mse_license_key}
EOT

source ~/.bash_profile

curl -fsSL https://static-aliyun-doc.oss-cn-hangzhou.aliyuncs.com/install-script/use-mse-to-implement-comprehensive-traffic-protection/install.sh | bash
EOF
  )
}

# Create a Virtual Private Cloud (VPC) to provide an isolated network environment
resource "alicloud_vpc" "vpc" {
  cidr_block = var.vpc_config.cidr_block
  vpc_name   = var.vpc_config.vpc_name
}

# Create a VSwitch to divide a subnet within the VPC
resource "alicloud_vswitch" "vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.vswitch_config.cidr_block
  zone_id      = var.vswitch_config.zone_id
  vswitch_name = var.vswitch_config.vswitch_name
}

# Create a security group as a virtual firewall to control network access to ECS instances
resource "alicloud_security_group" "security_group" {
  vpc_id              = alicloud_vpc.vpc.id
  security_group_name = var.security_group_config.security_group_name
}

# Add security group rules to control inbound and outbound traffic
resource "alicloud_security_group_rule" "rules" {
  for_each = { for rule in var.security_group_rules : "${rule.type}-${rule.ip_protocol}-${rule.port_range}" => rule }

  type              = each.value.type
  ip_protocol       = each.value.ip_protocol
  nic_type          = each.value.nic_type
  policy            = each.value.policy
  port_range        = each.value.port_range
  priority          = each.value.priority
  security_group_id = alicloud_security_group.security_group.id
  cidr_ip           = each.value.cidr_ip
}

# Create an ECS instance (cloud server)
resource "alicloud_instance" "ecs_instance" {
  instance_name              = var.instance_config.instance_name
  image_id                   = var.instance_config.image_id
  instance_type              = var.instance_config.instance_type
  system_disk_category       = var.instance_config.system_disk_category
  security_groups            = [alicloud_security_group.security_group.id]
  vswitch_id                 = alicloud_vswitch.vswitch.id
  password                   = var.instance_config.password
  internet_max_bandwidth_out = var.instance_config.internet_max_bandwidth_out
}

# Create a cloud assistant command for deploying the application
resource "alicloud_ecs_command" "run_command" {
  name            = var.ecs_command_config.name
  command_content = var.custom_ecs_command_script != null ? var.custom_ecs_command_script : local.default_ecs_command_script
  working_dir     = var.ecs_command_config.working_dir
  type            = var.ecs_command_config.type
  timeout         = var.ecs_command_config.timeout
}

# Execute the cloud assistant command on the specified ECS instance
resource "alicloud_ecs_invocation" "invoke_script" {
  instance_id = [alicloud_instance.ecs_instance.id]
  command_id  = alicloud_ecs_command.run_command.id
  timeouts {
    create = "15m"
  }
}