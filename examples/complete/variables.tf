variable "region" {
  description = "The region where to deploy the resources"
  type        = string
  default     = "cn-hangzhou"
}

variable "instance_type" {
  description = "ECS instance type"
  type        = string
  default     = "ecs.t6-c1m2.large"
}

variable "ecs_instance_password" {
  description = "ECS instance login password. Length 8-30, must contain three items (uppercase letters, lowercase letters, numbers, special symbols in ()`~!@#$%^&*_-+=|{}[]:;'<>,.?/)"
  type        = string
  sensitive   = true
}

variable "mse_license_key" {
  description = "MSE License Key for current environment. Login MSE console: https://mse.console.aliyun.com, click Governance Center > Application Governance, select region at the top, click View License Key in the upper right corner to get MSE License Key."
  type        = string
  sensitive   = true
}