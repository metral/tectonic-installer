resource "azurerm_lb" "workers_lb" {
  name                = "${var.cluster_name}-workers-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration {
    name = "console"

    subnet_id                     = "${var.subnet}"
    private_ip_address_allocation = "dynamic"
  }
}
