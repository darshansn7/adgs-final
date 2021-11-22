provider "azurerm" {
  skip_provider_registration = true
  features {}
}

module "vm1" {
  source = "./../src"
  #
  vm_rg                 = "aianoaddarrsg01"
  rg_location           = "eastus2"
  vnet_name             = "aianoaddapvpc01"
  subnet_name           = "aianoaddazviz01"
  managed_disk_required = true
  managed_disk_config   = var.managed_disk_config
  #nic
  nic_name                          = local.vm1_nic_name
  nic_config_name                   = "vm_internal"
  nic_private_ip_address_allocation = "Dynamic"

  #key-vault
  vm_key_name        = local.vm1_key_name
  key_vault_name     = "test-key-vault4589"
  keyvault_vm_secret = local.vm1_keyvault_vm_secret

  #vm
  virtual_machine_name            = local.virtual_machine1_name
  vm_size                         = "Standard_D4s_v3"
  vm_source_image_id              = ""
  vm_source_image_publisher       = "OpenLogic"
  vm_source_image_offer           = "CentOS"
  vm_source_image_sku             = "7.4"
  vm_source_image_version         = "latest"
  vm_os_disk_name                 = "osdisk"
  vm_os_disk_caching              = "ReadWrite"
  vm_os_disk_storage_account_type = "Standard_LRS"
  vm_computer_name                = "aipuser1"
  vm_admin_username               = "aipuser1"

  #ansible
  vm_packages             = ["jdk-11.0.12_linux-x64_bin.rpm", "apache-zookeeper-3.5.6-bin.tar.gz"]
  playbooks               = ["java.yml", "zk-install.yml"]
  zookeeper_host_name     = ""
  elasticsearch_host_name = ""
  private_key             = "./${local.virtual_machine1_name}/${local.vm1_key_name}.pem"
  client_id               = var.client_id
  client_secret           = var.client_secret
  tenant_id               = var.tenant_id
  subscription_id         = var.subscription_id
  storage_account_name    = "adgsvmpackages"
  container_name          = "packages"
  custom_data             = filebase64("${path.module}/eg.sh")
  common_tags             = local.common_tags
  # #vm backup
  # recovery_services_vault_name = local.recovery_services_vault_name
  # recovery_services_vault_sku  = "Standard"
  # vm_backup_policy_name        = local.vm_backup_policy_name
  # # policy
  # time_zone                      = "UTC"
  # instant_restore_retention_days = 2
  # backup_frequency               = "Daily"
  # backup_time                    = "06:30"
  # retention_daily_count          = 10
  # soft_delete_enabled            = true
}


module "vm2" {
  source = "./../src"
  #
  vm_rg       = "aianoaddarrsg01"
  rg_location = "eastus2"
  vnet_name   = "aianoaddapvpc01"
  subnet_name = "aianoaddazviz01"

  #nic
  nic_name                          = local.vm2_nic_name
  nic_config_name                   = "vm_internal"
  nic_private_ip_address_allocation = "Dynamic"

  #key-vault
  vm_key_name        = local.vm2_key_name
  key_vault_name     = "test-key-vault4589"
  keyvault_vm_secret = local.vm2_keyvault_vm_secret

  #vm
  virtual_machine_name            = local.virtual_machine2_name
  vm_size                         = "Standard_D3_v2"
  vm_source_image_id              = ""
  vm_source_image_publisher       = "OpenLogic"
  vm_source_image_offer           = "CentOS"
  vm_source_image_sku             = "7.4"
  vm_source_image_version         = "latest"
  vm_os_disk_name                 = "osdisk"
  vm_os_disk_caching              = "ReadWrite"
  vm_os_disk_storage_account_type = "Standard_LRS"
  vm_computer_name                = "aipuser2"
  vm_admin_username               = "aipuser2"

  #ansible
  vm_packages             = ["jdk-11.0.12_linux-x64_bin.rpm", "elasticsearch-7.2.1-x86_64.rpm", "Saga_Server.zip"]
  playbooks               = ["java.yml", "elastic-install.yml", "saga-install.yml"]
  zookeeper_host_name     = module.vm1.virtual_machine_admin_username
  elasticsearch_host_name = ""
  private_key             = "./${local.virtual_machine2_name}/${local.vm2_key_name}.pem"
  client_id               = var.client_id
  client_secret           = var.client_secret
  tenant_id               = var.tenant_id
  subscription_id         = var.subscription_id
  storage_account_name    = "adgsvmpackages"
  container_name          = "packages"
  custom_data             = filebase64("${path.module}/eg.sh")
  common_tags             = local.common_tags
  # #vm backup
  # recovery_services_vault_name = local.recovery_services_vault_name
  # recovery_services_vault_sku  = "Standard"
  # vm_backup_policy_name        = local.vm_backup_policy_name
  # # policy
  # time_zone                      = "UTC"
  # instant_restore_retention_days = 2
  # backup_frequency               = "Daily"
  # backup_time                    = "06:30"
  # retention_daily_count          = 10
  # soft_delete_enabled            = true
  depends_on = [module.vm1]
}

module "vm3" {
  source = "./../src"
  #
  vm_rg       = "aianoaddarrsg01"
  rg_location = "eastus2"
  vnet_name   = "aianoaddapvpc01"
  subnet_name = "aianoaddazviz01"

  #nic
  nic_name                          = local.vm3_nic_name
  nic_config_name                   = "vm_internal"
  nic_private_ip_address_allocation = "Dynamic"

  #key-vault
  vm_key_name        = local.vm3_key_name
  key_vault_name     = "test-key-vault4589"
  keyvault_vm_secret = local.vm3_keyvault_vm_secret

  #vm
  virtual_machine_name            = local.virtual_machine3_name
  vm_size                         = "Standard_D3_v2"
  vm_source_image_id              = ""
  vm_source_image_publisher       = "OpenLogic"
  vm_source_image_offer           = "CentOS"
  vm_source_image_sku             = "7.4"
  vm_source_image_version         = "latest"
  vm_os_disk_name                 = "osdisk"
  vm_os_disk_caching              = "ReadWrite"
  vm_os_disk_storage_account_type = "Standard_LRS"
  vm_computer_name                = "aipuser3"
  vm_admin_username               = "aipuser3"

  #ansible
  vm_packages             = ["jdk-11.0.12_linux-x64_bin.rpm", "python-lxml-3.2.1-4.el7.x86_64.rpm", "aspire-4.0-SNAPSHOT.tar.gz"]
  playbooks               = ["java.yml", "aspire-master-install.yml"]
  zookeeper_host_name     = module.vm1.virtual_machine_admin_username
  elasticsearch_host_name = module.vm2.virtual_machine_admin_username
  private_key             = "./${local.virtual_machine3_name}/${local.vm3_key_name}.pem"
  client_id               = var.client_id
  client_secret           = var.client_secret
  tenant_id               = var.tenant_id
  subscription_id         = var.subscription_id
  storage_account_name    = "adgsvmpackages"
  container_name          = "packages"
  custom_data             = filebase64("${path.module}/eg.sh")
  common_tags             = local.common_tags
  # #vm backup
  # recovery_services_vault_name = local.recovery_services_vault_name
  # recovery_services_vault_sku  = "Standard"
  # vm_backup_policy_name        = local.vm_backup_policy_name
  # # policy
  # time_zone                      = "UTC"
  # instant_restore_retention_days = 2
  # backup_frequency               = "Daily"
  # backup_time                    = "06:30"
  # retention_daily_count          = 10
  # soft_delete_enabled            = true
  depends_on = [module.vm2]
}




module "vm4" {
  source = "./../src"
  #
  vm_rg       = "aianoaddarrsg01"
  rg_location = "eastus2"
  vnet_name   = "aianoaddapvpc01"
  subnet_name = "aianoaddazviz01"
  #niic
  nic_name                          = local.vm4_nic_name
  nic_config_name                   = "vm_internal"
  nic_private_ip_address_allocation = "Dynamic"

  #key-vault
  vm_key_name        = local.vm4_key_name
  key_vault_name     = "test-key-vault4589"
  keyvault_vm_secret = local.vm4_keyvault_vm_secret

  #vm
  virtual_machine_name            = local.virtual_machine4_name
  vm_size                         = "Standard_D4s_v3"
  vm_source_image_id              = ""
  vm_source_image_publisher       = "OpenLogic"
  vm_source_image_offer           = "CentOS"
  vm_source_image_sku             = "7.4"
  vm_source_image_version         = "latest"
  vm_os_disk_name                 = "osdisk"
  vm_os_disk_caching              = "ReadWrite"
  vm_os_disk_storage_account_type = "Standard_LRS"
  vm_computer_name                = "aipuser4"
  vm_admin_username               = "aipuser4"
  custom_data                     = filebase64("${path.module}/eg.sh")

  #ansible
  vm_packages             = ["jdk-11.0.12_linux-x64_bin.rpm", "python-lxml-3.2.1-4.el7.x86_64.rpm", "aspire-4.0-SNAPSHOT.tar.gz"]
  playbooks               = ["java.yml", "aspire-worker-install.yml"]
  zookeeper_host_name     = module.vm1.virtual_machine_admin_username
  elasticsearch_host_name = module.vm2.virtual_machine_admin_username
  private_key             = "./${local.virtual_machine4_name}/${local.vm4_key_name}.pem"
  client_id               = var.client_id
  client_secret           = var.client_secret
  tenant_id               = var.tenant_id
  subscription_id         = var.subscription_id
  storage_account_name    = "adgsvmpackages"
  container_name          = "packages"

  common_tags = local.common_tags
  # #vm backup
  # recovery_services_vault_name = local.recovery_services_vault_name
  # recovery_services_vault_sku  = "Standard"
  # vm_backup_policy_name        = local.vm_backup_policy_name
  # # policy
  # time_zone                      = "UTC"
  # instant_restore_retention_days = 2
  # backup_frequency               = "Daily"
  # backup_time                    = "06:30"
  # retention_daily_count          = 10
  # soft_delete_enabled            = true
  depends_on = [module.vm3]
}
