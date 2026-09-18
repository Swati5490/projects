resource "azurerm_network_interface" "main" {
  for_each = var.virtual_machines

  name                = each.value.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${each.value.name}-ipconfig"
    subnet_id                     = var.subnet_ids[each.value.subnet_key]
    private_ip_address_allocation = "Dynamic"
  }

  tags = merge(var.tags, { Environment = var.environment })
}

resource "azurerm_linux_virtual_machine" "main" {
  for_each = var.virtual_machines

  name                            = each.value.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = each.value.size
  admin_username                  = each.value.admin_username
  network_interface_ids           = [azurerm_network_interface.main[each.key].id]
  disable_password_authentication = var.admin_ssh_public_key != null

  os_disk {
    name                 = "${each.value.name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = each.value.os_disk_storage_account_type
    disk_size_gb         = each.value.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  tags = merge(var.tags, { Environment = var.environment })
}

resource "azurerm_managed_disk" "data" {
  for_each = {
    for disk in flatten([
      for vm_key, vm in var.virtual_machines : [
        for disk_key, disk_config in vm.data_disks : {
          key     = "${vm_key}.${disk_key}"
          name    = disk_config.name
          size    = disk_config.size
          storage = disk_config.storage_account_type
        }
      ]
    ]) : disk.key => disk
  }

  name                 = each.value.name
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.storage
  create_option        = "Empty"
  disk_size_gb         = each.value.size

  tags = merge(var.tags, { Environment = var.environment })
}

resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  for_each = {
    for disk in flatten([
      for vm_key, vm in var.virtual_machines : [
        for disk_key, disk_config in vm.data_disks : {
          key    = "${vm_key}.${disk_key}"
          vm_key = vm_key
          lun    = disk_config.lun
          cache  = disk_config.caching
        }
      ]
    ]) : disk.key => disk
  }

  managed_disk_id    = azurerm_managed_disk.data[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.main[each.value.vm_key].id
  lun                = each.value.lun
  caching            = each.value.cache
}
