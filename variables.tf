# ------------------------------------------------------------------------------
# Module Input Variables
#
# This file defines all configurable input variables for this Terraform module.
# Each variable includes detailed 'description' to explain its purpose, format
# and default value logic. Please refer to these descriptions to configure
# the module correctly.
# ------------------------------------------------------------------------------

variable "mse_license_key" {
  type        = string
  description = "MSE License Key for current environment. Login MSE console: https://mse.console.aliyun.com, click Governance Center > Application Governance, select region at the top, click View License Key in the upper right corner to get MSE License Key."
  sensitive   = true
}

variable "vpc_config" {
  description = "The parameters of VPC. The attribute 'cidr_block' is required."
  type = object({
    cidr_block = string
    vpc_name   = optional(string, "mse-vpc")
  })
  default = {
    cidr_block = null
  }
}

variable "vswitch_config" {
  description = "The parameters of VSwitch. The attributes 'cidr_block' and 'zone_id' are required. zone_id is immutable after creation."
  type = object({
    cidr_block   = string
    zone_id      = string
    vswitch_name = optional(string, "mse-vswitch")
  })
}

variable "security_group_config" {
  description = "The parameters of security group."
  type = object({
    security_group_name = optional(string, "mse-security-group")
  })
  default = {}
}

variable "security_group_rules" {
  description = "List of security group rules to create."
  type = list(object({
    type        = string
    ip_protocol = string
    nic_type    = optional(string, "intranet")
    policy      = optional(string, "accept")
    port_range  = string
    priority    = optional(number, 1)
    cidr_ip     = string
  }))
  default = [
    {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "80/80"
      cidr_ip     = "192.168.0.0/24"
    }
  ]
}

variable "instance_config" {
  description = "The parameters of ECS instance. The attributes 'image_id', 'instance_type', 'system_disk_category' and 'password' are required."
  type = object({
    image_id                   = string
    instance_type              = string
    system_disk_category       = string
    password                   = string
    instance_name              = optional(string, "mse-ecs-instance")
    internet_max_bandwidth_out = optional(number, 5)
  })
  default = {
    image_id             = null
    instance_type        = null
    system_disk_category = null
    password             = null
  }
  sensitive = true
}

variable "ecs_command_config" {
  description = "The parameters of ECS command."
  type = object({
    name        = optional(string, "mse-command")
    working_dir = optional(string, "/root")
    type        = optional(string, "RunShellScript")
    timeout     = optional(number, 3600)
  })
  default = {}
}

variable "custom_ecs_command_script" {
  description = "Custom ECS command script for MSE traffic protection deployment. If not provided, the default script will be used."
  type        = string
  default     = null
}