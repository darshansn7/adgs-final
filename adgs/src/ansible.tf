#############################################################################
####################           ansible    ###################################
#############################################################################

resource "null_resource" "azcli" {
triggers = {always_run = "${timestamp()}"}
  provisioner "remote-exec" {
    inline = [
      "echo 'build ssh connection' "
    ]
  }
  connection {
    host        = azurerm_network_interface.vm_nic.private_ip_address
    type        = "ssh"
    user        = var.vm_admin_username
    private_key = local.private_key
    agent       = false
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${azurerm_network_interface.vm_nic.private_ip_address}, --private-key ${var.private_key} ${path.module}/ansible/azcli.yml -u ${var.vm_admin_username} --extra-vars "ansible_user="${var.vm_admin_username}" ansible_passowrd="${random_password.password.result}""
  }
  depends_on = [module.disk]
}



resource "null_resource" "packages_download" {
  count = length(var.vm_packages)
  provisioner "remote-exec" {
    inline = [
      "echo 'build ssh connection' "
    ]
  }
  connection {
    host        = azurerm_network_interface.vm_nic.private_ip_address
    type        = "ssh"
    user        = var.vm_admin_username
    private_key = local.private_key
    agent       = false
  }
  #download package
  provisioner "remote-exec" {
    inline = ["cd /tmp",
      "az login --service-principal --username '${var.client_id}' --password '${var.client_secret}' --tenant '${var.tenant_id}'",
      "az account set --subscription '${var.subscription_id}'",
      "az account list --output table",
      "az storage blob download --account-name '${var.storage_account_name}' --container-name '${var.container_name}' --name '${var.vm_packages[count.index]}' --file '${var.vm_packages[count.index]}'"
    ]
  }
  depends_on = [null_resource.azcli]
}

resource "null_resource" "install_package1" {
triggers = {always_run = "${timestamp()}"}
  provisioner "remote-exec" {
    inline = [
      "echo 'build ssh connection' "
    ]
  }
  connection {
    host        = azurerm_network_interface.vm_nic.private_ip_address
    type        = "ssh"
    user        = var.vm_admin_username
    private_key = local.private_key
    agent       = false
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${azurerm_network_interface.vm_nic.private_ip_address}, --private-key ${var.private_key} ${path.module}/ansible/main.yml -u ${var.vm_admin_username}"
  }
  depends_on = [null_resource.packages_download, local_file.playbooks, local_file.update_vars_yaml]
}


