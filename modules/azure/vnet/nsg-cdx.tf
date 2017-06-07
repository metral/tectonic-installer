########
## Azure Load Balancer / API / Console NSG Rules
########

resource "azurerm_network_security_rule" "cdx_alb_probe" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-alb_probe"
  priority                    = 295
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_api}"
}

resource "azurerm_network_security_group" "cdx_api" {
  count               = "${var.external_nsg_api == "" ? 1 : 0}"
  name                = "${var.tectonic_cluster_name}-api"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_network_security_rule" "cdx_api_egress" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-api_egress"
  priority                    = 1990
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_api}"
}

resource "azurerm_network_security_rule" "cdx_api_ingress_https" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-api_ingress_https"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_api}"
}

resource "azurerm_network_security_group" "cdx_console" {
  count               = "${var.external_nsg_api == "" ? 1 : 0}"
  name                = "${var.tectonic_cluster_name}-console"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_network_security_rule" "cdx_console_egress" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-console_egress"
  priority                    = 1995
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_api}"
}

resource "azurerm_network_security_rule" "cdx_console_ingress_https" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-console_ingress_https"
  priority                    = 305
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_api}"
}

resource "azurerm_network_security_rule" "cdx_console_ingress_http" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-console_ingress_http"
  priority                    = 310
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_api}"
}

########
## etcd NSG Rules
########

resource "azurerm_network_security_group" "cdx_etcd" {
  count               = "${var.external_nsg_etcd == "" ? 1 : 0}"
  name                = "${var.tectonic_cluster_name}-etcd"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_network_security_rule" "cdx_etcd_egress" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-etcd_egress"
  priority                    = 2000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_etcd}"
}

resource "azurerm_network_security_rule" "cdx_etcd_ingress_ssh" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-etcd_ingress_ssh"
  priority                    = 400
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${var.ssh_network_internal}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_etcd}"
}

# TODO: Add external SSH rule
resource "azurerm_network_security_rule" "cdx_etcd_ingress_ssh_admin" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-etcd_ingress_ssh_admin"
  priority                    = 405
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${var.ssh_network_external}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_etcd}"
}

resource "azurerm_network_security_rule" "cdx_etcd_ingress_ssh_self" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-etcd_ingress_ssh_self"
  priority               = 410
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "22"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_etcd}"
}

resource "azurerm_network_security_rule" "cdx_etcd_ingress_ssh_from_master" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-etcd_ingress_services_from_console"
  priority               = 415
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "22"

  # TODO: Need to allow traffic from master
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_etcd}"
}

resource "azurerm_network_security_rule" "cdx_etcd_ingress_client_self" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-etcd_ingress_client_self"
  priority               = 420
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "2379"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_etcd}"
}

resource "azurerm_network_security_rule" "cdx_etcd_ingress_client_master" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-etcd_ingress_client_master"
  priority               = 425
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "2379"

  # TODO: Need to allow traffic from master
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_etcd}"
}

resource "azurerm_network_security_rule" "cdx_etcd_ingress_client_worker" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-etcd_ingress_client_worker"
  priority               = 430
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "2379"

  # TODO: Need to allow traffic from workers
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_etcd}"
}

resource "azurerm_network_security_rule" "cdx_etcd_ingress_peer" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-etcd_ingress_peer"
  priority               = 435
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "2380"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_etcd}"
}

########
## Tectonic Master NSG Rules
########

resource "azurerm_network_security_group" "cdx_master" {
  count               = "${var.external_nsg_master == "" ? 1 : 0}"
  name                = "${var.tectonic_cluster_name}-master"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_network_security_rule" "cdx_master_egress" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-master_egress"
  priority                    = 2005
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

resource "azurerm_network_security_rule" "cdx_master_ingress_ssh" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-master_ingress_ssh"
  priority                    = 500
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${var.ssh_network_internal}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

# TODO: Add external SSH rule
resource "azurerm_network_security_rule" "cdx_master_ingress_ssh_admin" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-master_ingress_ssh_admin"
  priority                    = 505
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${var.ssh_network_external}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

resource "azurerm_network_security_rule" "cdx_master_ingress_flannel" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-master_ingress_flannel"
  priority               = 510
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "udp"
  source_port_range      = "*"
  destination_port_range = "4789"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

resource "azurerm_network_security_rule" "cdx_master_ingress_flannel_from_worker" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-master_ingress_flannel_from_worker"
  priority               = 515
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "udp"
  source_port_range      = "*"
  destination_port_range = "4789"

  # TODO: Need to allow traffic from worker
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

# TODO: Add rule(s) for Tectonic ingress

resource "azurerm_network_security_rule" "cdx_master_ingress_node_exporter" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-master_ingress_node_exporter"
  priority               = 520
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "9100"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

resource "azurerm_network_security_rule" "cdx_master_ingress_node_exporter_from_worker" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-master_ingress_node_exporter_from_worker"
  priority               = 525
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "9100"

  # TODO: Need to allow traffic from worker
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

resource "azurerm_network_security_rule" "cdx_master_ingress_services" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-master_ingress_services"
  priority               = 530
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "30000-32767"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

resource "azurerm_network_security_rule" "cdx_master_ingress_services_from_console" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-master_ingress_services_from_console"
  priority               = 535
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "30000-32767"

  # TODO: Need to allow traffic from console
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

resource "azurerm_network_security_rule" "cdx_master_ingress_etcd_lb" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-master_ingress_etcd"
  priority               = 540
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "2379"

  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

resource "azurerm_network_security_rule" "cdx_master_ingress_etcd_self" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-master_ingress_etcd_self"
  priority               = 545
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "2379-2380"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

resource "azurerm_network_security_rule" "cdx_master_ingress_bootstrap_etcd" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-master_ingress_bootstrap_etcd"
  priority               = 550
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "12379-12380"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

resource "azurerm_network_security_rule" "cdx_master_ingress_kubelet_insecure" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-master_ingress_kubelet_insecure"
  priority               = 555
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "10250"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

resource "azurerm_network_security_rule" "cdx_master_ingress_kubelet_insecure_from_worker" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-master_ingress_kubelet_insecure_from_worker"
  priority               = 560
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "10250"

  # TODO: Need to allow traffic from worker
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

resource "azurerm_network_security_rule" "cdx_master_ingress_kubelet_secure" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-master_ingress_kubelet_secure"
  priority               = 565
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "10255"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

resource "azurerm_network_security_rule" "cdx_master_ingress_kubelet_secure_from_worker" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-master_ingress_kubelet_secure_from_worker"
  priority               = 570
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "10255"

  # TODO: Need to allow traffic from worker
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

# TODO: Review NSG
resource "azurerm_network_security_rule" "cdx_master_ingress_http" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-master_ingress_http"
  priority                    = 575
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

# TODO: Review NSG
resource "azurerm_network_security_rule" "cdx_master_ingress_https" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-master_ingress_https"
  priority                    = 580
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

# TODO: Review NSG
resource "azurerm_network_security_rule" "cdx_master_ingress_heapster" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-master_ingress_heapster"
  priority               = 585
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "4194"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

# TODO: Review NSG
resource "azurerm_network_security_rule" "cdx_master_ingress_heapster_from_worker" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-master_ingress_heapster_from_worker"
  priority               = 590
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "4194"

  # TODO: Need to allow traffic from worker
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_master}"
}

########
## Tectonic Worker NSG Rules
########

resource "azurerm_network_security_group" "cdx_worker" {
  count               = "${var.external_nsg_worker == "" ? 1 : 0}"
  name                = "${var.tectonic_cluster_name}-worker"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_network_security_rule" "cdx_worker_egress" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-worker_egress"
  priority                    = 2010
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}

resource "azurerm_network_security_rule" "cdx_worker_ingress_ssh" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-worker_ingress_ssh"
  priority                    = 600
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${var.ssh_network_internal}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}

# TODO: Add external SSH rule
resource "azurerm_network_security_rule" "cdx_worker_ingress_ssh_admin" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-worker_ingress_ssh_admin"
  priority                    = 605
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${var.ssh_network_external}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}

resource "azurerm_network_security_rule" "cdx_worker_ingress_services" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-worker_ingress_services"
  priority               = 610
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "30000-32767"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}

resource "azurerm_network_security_rule" "cdx_worker_ingress_services_from_console" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-worker_ingress_services_from_console"
  priority               = 615
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "30000-32767"

  # TODO: Need to allow traffic from console
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}

resource "azurerm_network_security_rule" "cdx_worker_ingress_flannel" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-worker_ingress_flannel"
  priority               = 620
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "udp"
  source_port_range      = "*"
  destination_port_range = "4789"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}

resource "azurerm_network_security_rule" "cdx_worker_ingress_flannel_from_master" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-worker_ingress_flannel_from_master"
  priority               = 625
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "udp"
  source_port_range      = "*"
  destination_port_range = "4789"

  # TODO: Need to allow traffic from master
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}

resource "azurerm_network_security_rule" "cdx_worker_ingress_kubelet_insecure" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-worker_ingress_kubelet_insecure"
  priority               = 630
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "10250"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}

resource "azurerm_network_security_rule" "cdx_worker_ingress_kubelet_insecure_from_master" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-worker_ingress_kubelet_insecure_from_master"
  priority               = 635
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "10250"

  # TODO: Need to allow traffic from master
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}

resource "azurerm_network_security_rule" "cdx_worker_ingress_kubelet_secure" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-worker_ingress_kubelet_secure"
  priority               = 640
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "10255"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}

resource "azurerm_network_security_rule" "cdx_worker_ingress_kubelet_secure_from_master" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-worker_ingress_kubelet_secure_from_master"
  priority               = 645
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "10255"

  # TODO: Need to allow traffic from master
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}

resource "azurerm_network_security_rule" "cdx_worker_ingress_node_exporter" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-worker_ingress_node_exporter"
  priority               = 650
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "9100"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}

resource "azurerm_network_security_rule" "cdx_worker_ingress_node_exporter_from_master" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-worker_ingress_node_exporter_from_master"
  priority               = 655
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "9100"

  # TODO: Need to allow traffic from master
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}

resource "azurerm_network_security_rule" "cdx_worker_ingress_heapster" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-worker_ingress_heapster"
  priority               = 660
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "4194"

  # TODO: Need to allow traffic from self
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}

resource "azurerm_network_security_rule" "cdx_worker_ingress_heapster_from_master" {
  count                  = "${var.create_nsg_rules ? 1 : 0}"
  name                   = "${var.tectonic_cluster_name}-worker_ingress_heapster_from_master"
  priority               = 665
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "tcp"
  source_port_range      = "*"
  destination_port_range = "4194"

  # TODO: Need to allow traffic from master
  source_address_prefix       = "${var.vnet_cidr_block}"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}

# TODO: Add rules for self-hosted etcd (etcd-operator)

# TODO: Review NSG
resource "azurerm_network_security_rule" "cdx_worker_ingress_http" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-worker_ingress_http"
  priority                    = 670
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}

# TODO: Review NSG
resource "azurerm_network_security_rule" "cdx_worker_ingress_https" {
  count                       = "${var.create_nsg_rules ? 1 : 0}"
  name                        = "${var.tectonic_cluster_name}-worker_ingress_https"
  priority                    = 675
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.external_resource_group == "" ? var.resource_group_name : var.external_resource_group}"
  network_security_group_name = "${var.external_nsg_worker}"
}
