resource "azurerm_managed_disk" "main" {
  for_each             = var.managed_disk_config
  name                 = "${var.virtual_machine_name}" - "${each.value["name"]}"
  location             = var.rg_location
  resource_group_name  = var.vm_rg
  storage_account_type = each.value["storage_account_type"]
  create_option        = "Empty"
  disk_size_gb         = each.value["disk_size_gb"]
  tags                 = var.common_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  for_each           = var.managed_disk_config
  managed_disk_id    = azurerm_managed_disk.main.id
  virtual_machine_id = var.virtual_machine_id
  lun                = each.value["lun"]
  caching            = each.value["caching"]
  depends_on         = [azurerm_managed_disk.main]
}
