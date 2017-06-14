resource "azurerm_network_interface" "etcd_nic" {
  count               = "${var.etcd_count}"
  name                = "${var.tectonic_cluster_name}-etcd-nic-${count.index}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                                    = "tectonic_etcd_configuration"
    subnet_id                               = "${var.external_vnet_name == "" ?  join(" ", azurerm_subnet.master_subnet.*.id) : var.external_master_subnet_id }"
    private_ip_address_allocation           = "dynamic"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.etcd-lb.id}"]
  }
}

resource "azurerm_network_security_group" "etcd_group" {
  name                = "${var.tectonic_cluster_name}-etcd"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                       = "ssh"
    source_port_range          = "*"
    destination_port_range     = 22
    protocol                   = "Tcp"
    destination_address_prefix = "0.0.0.0/0"
    source_address_prefix      = "VirtualNetwork"
    access                     = "Allow"
    priority                   = "100"
    direction                  = "Inbound"
  }

  security_rule {
    name                       = "etcd-client-perr"
    source_port_range          = "*"
    destination_port_range     = "2379-2380"
    protocol                   = "Tcp"
    destination_address_prefix = "0.0.0.0/0"
    source_address_prefix      = "VirtualNetwork"
    access                     = "Allow"
    priority                   = "101"
    direction                  = "Inbound"
  }

  security_rule {
    name                       = "all-in"
    source_port_range          = "*"
    destination_port_range     = "*"
    protocol                   = "*"
    destination_address_prefix = "0.0.0.0/0"
    source_address_prefix      = "0.0.0.0/0"
    access                     = "Allow"
    priority                   = "103"
    direction                  = "Inbound"
  }

  security_rule {
    name                       = "all-out"
    source_port_range          = "*"
    destination_port_range     = "*"
    protocol                   = "*"
    destination_address_prefix = "Internet"
    source_address_prefix      = "0.0.0.0/0"
    access                     = "Allow"
    priority                   = "104"
    direction                  = "Outbound"
  }
}

resource "azurerm_lb" "tectonic_etcd_lb" {
  name                = "${var.tectonic_cluster_name}-etcd-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration {
    name = "default"

    subnet_id                     = "${var.subnet}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_lb_rule" "etcd-lb" {
  name                           = "${var.tectonic_cluster_name}-etcd-lb-rule-client"
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.tectonic_etcd_lb.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.etcd-lb.id}"
  probe_id                       = "${azurerm_lb_probe.etcd-lb.id}"
  protocol                       = "tcp"
  frontend_port                  = 2379
  backend_port                   = 2379
  frontend_ip_configuration_name = "default"
}

resource "azurerm_lb_probe" "etcd-lb" {
  name                = "${var.tectonic_cluster_name}-etcd-lb-probe"
  loadbalancer_id     = "${azurerm_lb.tectonic_etcd_lb.id}"
  resource_group_name = "${var.resource_group_name}"
  protocol            = "Tcp"
  port                = 2379
}

resource "azurerm_lb_backend_address_pool" "etcd-lb" {
  name                = "${var.tectonic_cluster_name}-etcd-lb-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.tectonic_etcd_lb.id}"
}

data "template_file" "scripts_nsupdate" {
  template = <<EOF
update delete $${cluster_name}-etcd.$${base_domain} A
update add $${cluster_name}-etcd.$${base_domain} 0 A $${etcd_lb_ip_address}

send
EOF

  vars {
    cluster_name       = "${var.tectonic_cluster_name}"
    base_domain        = "${var.base_domain}"
    etcd_lb_ip_address = "${azurerm_lb.tectonic_etcd_lb.frontend_ip_configuration.0.private_ip_address}"
  }
}

resource "local_file" "nsupdate" {
  content  = "${data.template_file.scripts_nsupdate.rendered}"
  filename = "${path.cwd}/generated/dns/etcd-dns.txt"
}

resource "null_resource" "scripts_nsupdate" {
  depends_on = ["local_file.nsupdate"]

  triggers {
    md5 = "${md5(data.template_file.scripts_nsupdate.rendered)}"
  }

  provisioner "local-exec" {
    command = "nsupdate -d ${path.cwd}/generated/dns/etcd-dns.txt"
  }
}
