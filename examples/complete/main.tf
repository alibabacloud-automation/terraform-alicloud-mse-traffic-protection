# Configure the Alibaba Cloud Provider
provider "alicloud" {
  region = var.region
}

# Query available zones
data "alicloud_zones" "default" {
  available_disk_category     = "cloud_essd"
  available_resource_creation = "VSwitch"
  available_instance_type     = var.instance_type
}

# Query available images
data "alicloud_images" "default" {
  name_regex  = "^aliyun_3_x64_20G_alibase_.*"
  most_recent = true
  owners      = "system"
}

# Create a random suffix for resource naming
resource "random_string" "suffix" {
  length  = 8
  lower   = true
  upper   = false
  numeric = false
  special = false
}

# Call the MSE traffic protection module
module "mse_traffic_protection" {
  source = "../../"

  mse_license_key = var.mse_license_key

  vpc_config = {
    cidr_block = "192.168.0.0/16"
    vpc_name   = "mse-vpc-${random_string.suffix.result}"
  }

  vswitch_config = {
    cidr_block   = "192.168.0.0/24"
    zone_id      = data.alicloud_zones.default.zones[0].id
    vswitch_name = "mse-vswitch-${random_string.suffix.result}"
  }

  security_group_config = {
    security_group_name = "mse-sg-${random_string.suffix.result}"
  }

  security_group_rules = [
    {
      type        = "ingress"
      ip_protocol = "tcp"
      nic_type    = "intranet"
      policy      = "accept"
      port_range  = "80/80"
      priority    = 1
      cidr_ip     = "192.168.0.0/24"
    }
  ]

  instance_config = {
    image_id                   = data.alicloud_images.default.images[0].id
    instance_type              = var.instance_type
    system_disk_category       = "cloud_essd"
    password                   = var.ecs_instance_password
    instance_name              = "mse-ecs-${random_string.suffix.result}"
    internet_max_bandwidth_out = 5
  }

  ecs_command_config = {
    name        = "mse-command-${random_string.suffix.result}"
    working_dir = "/root"
    type        = "RunShellScript"
    timeout     = 3600
  }
}