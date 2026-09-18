output "network_interfaces" {
  value = {
    for key, nic in azurerm_network_interface.main : key => {
      id   = nic.id
      name = nic.name
    }
  }
}

output "virtual_machines" {
  value = {
    for key, vm in azurerm_linux_virtual_machine.main : key => {
      id   = vm.id
      name = vm.name
    }
  }
}

output "managed_disks" {
  value = {
    for key, disk in azurerm_managed_disk.data : key => {
      id   = disk.id
      name = disk.name
    }
  }
}
