resource "azurerm_lb" "tectonic_etcd_lb" {
  name                = "${var.cluster_name}-etcd-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration {
    name                          = "default"
    subnet_id                     = "${var.subnet}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_lb_rule" "etcd-lb" {
  name                           = "${var.cluster_name}-etcd-lb-rule-client"
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
  name                = "${var.cluster_name}-etcd-lb-probe"
  loadbalancer_id     = "${azurerm_lb.tectonic_etcd_lb.id}"
  resource_group_name = "${var.resource_group_name}"
  protocol            = "Tcp"
  port                = 2379
}

resource "azurerm_lb_backend_address_pool" "etcd-lb" {
  name                = "${var.cluster_name}-etcd-lb-pool"
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
    cluster_name       = "${var.cluster_name}"
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
