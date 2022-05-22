variable "resource_group_name" {
  type      = string
  default   = "packer"
  sensitive = false
}

variable "arm_client_id" {
  type      = string
  default   = "#"
  sensitive = true
}

variable "arm_client_secret" {
  type      = string
  default   = "#"
  sensitive = true
}

variable "arm_subscription_id" {
  type      = string
  default   = "#"
  sensitive = true
}

variable "location" {
  type      = string
  default   = "West Europe"
  sensitive = false
}

variable "image_name" {
  type      = string
  default   = "packer-ubuntu"
  sensitive = false
}

variable "vm_size" {
  type      = string
  default   = "Standard_B2s"
  sensitive = false
}

variable "os_image" {
  type = map(string)
  default = {
    os_type         = "Linux"
    image_offer     = "UbuntuServer"
    image_publisher = "Canonical"
    image_sku       = "16.04-LTS"
  }
  sensitive = false
}

variable "tags" {
  type = map(string)
  default = {
    owner          = "Nikolay Kyorov"
    deploymentType = "Packer"
  }
  sensitive = false
}

locals{
  image_name = "${var.image_name}-{{timestamp}}"
}
