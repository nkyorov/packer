source "azure-arm" "ubuntu" {

  # SPN
  client_id       = "${var.arm_client_id}"
  client_secret   = "${var.arm_client_secret}"
  subscription_id = "${var.arm_subscription_id}"

  # OS IMAGE
  os_type         = "${var.os_image.os_type}"
  image_offer     = "${var.os_image.image_offer}"
  image_publisher = "${var.os_image.image_publisher}"
  image_sku       = "${var.os_image.image_sku}"

  # VM
  location                          = "${var.location}"
  managed_image_name                = "${local.image_name}"
  managed_image_resource_group_name = "${var.resource_group_name}"
  vm_size                           = "${var.vm_size}"

  ########################
  # Temporary resources  #
  ########################
  # temp_resource_group_name = ""
  # temp_compute_name = ""
  # temp_nic_name = ""


  # os_disk_size_gb = 128
  # disk_additional_size = [32, 64, 128]
  # managed_image_storage_account_type = "Premium_LRS"
  # disk_caching_type = "ReadWrite"

  ########################
  #     Custom VNETS     #
  ########################  
  # virtual_network_name = ""
  # virtual_network_subnet_name = ""
  # virtual_network_resource_group_name = ""

  # user_data_file = ""
  # customer_data_file = ""


  azure_tags = var.tags
}

build {
  sources = ["source.azure-arm.ubuntu"]

  # Install Ansible
  provisioner "shell" {
    execute_command = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    script = var.init_script
  }
  
  # Setup OS using Ansible
  provisioner "ansible-local" {
    playbook_dir = var.ansible_role_path
    playbook_file = var.ansible_playbook_file
    clean_staging_directory = true
    #extra_argumenrs = ["--extra-vars","\"variable_one=${var.var_one}\""]
  }

  # Deprovision
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline = [
      "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
    ]
    inline_shebang = "/bin/sh -x"
  }
}
