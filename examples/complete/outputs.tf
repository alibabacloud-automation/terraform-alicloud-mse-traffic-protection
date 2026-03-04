output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.mse_traffic_protection.vpc_id
}

output "ecs_instance_id" {
  description = "The ID of the ECS instance"
  value       = module.mse_traffic_protection.ecs_instance_id
}

output "ecs_instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = module.mse_traffic_protection.ecs_instance_public_ip
}

output "ecs_login_address" {
  description = "Login address for the ECS instance that deployed the application"
  value       = module.mse_traffic_protection.ecs_login_address
}

output "demo_url" {
  description = "Web page access address for the application"
  value       = module.mse_traffic_protection.demo_url
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.mse_traffic_protection.security_group_id
}