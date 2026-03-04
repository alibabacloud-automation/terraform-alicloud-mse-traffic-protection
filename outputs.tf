# ------------------------------------------------------------------------------
# Module Outputs
#
# This file defines the values returned by the module after successful execution.
# These outputs can be referenced by other Terraform configurations or displayed
# to users after the apply command completes.
# ------------------------------------------------------------------------------

output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = alicloud_vpc.vpc.cidr_block
}

output "vswitch_id" {
  description = "The ID of the VSwitch"
  value       = alicloud_vswitch.vswitch.id
}

output "vswitch_cidr_block" {
  description = "The CIDR block of the VSwitch"
  value       = alicloud_vswitch.vswitch.cidr_block
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.security_group.id
}

output "ecs_instance_id" {
  description = "The ID of the ECS instance"
  value       = alicloud_instance.ecs_instance.id
}

output "ecs_instance_name" {
  description = "The name of the ECS instance"
  value       = alicloud_instance.ecs_instance.instance_name
}

output "ecs_instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = alicloud_instance.ecs_instance.public_ip
}

output "ecs_instance_private_ip" {
  description = "The private IP address of the ECS instance"
  value       = alicloud_instance.ecs_instance.private_ip
}

output "ecs_command_id" {
  description = "The ID of the ECS command"
  value       = alicloud_ecs_command.run_command.id
}

output "ecs_invocation_id" {
  description = "The ID of the ECS invocation"
  value       = alicloud_ecs_invocation.invoke_script.id
}

output "ecs_login_address" {
  description = "Login address for the ECS instance that deployed the application"
  value       = format("https://ecs-workbench.aliyun.com/?from=ecs&instanceType=ecs&regionId=%s&instanceId=%s&resourceGroupId=", data.alicloud_regions.current.regions[0].id, alicloud_instance.ecs_instance.id)
}

output "demo_url" {
  description = "Web page access address for the application"
  value       = format("http://%s:80", alicloud_instance.ecs_instance.public_ip)
}