## Workaround for https://github.com/coreos/tectonic-installer/issues/657
## Related to: https://github.com/Microsoft/azure-docs/blob/master/articles/load-balancer/load-balancer-internal-overview.md#limitations

resource "azurerm_lb" "proxy_lb" {
  name                = "${var.cluster_name}-api-proxy-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration {
    name                          = "api-proxy"
    subnet_id                     = "${var.subnet}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "api-proxy-lb" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.proxy_lb.id}"
  name                = "api-proxy-lb-pool"
}

resource "azurerm_lb_rule" "api-proxy-lb" {
  name                    = "api-proxy-lb-rule-443-443"
  resource_group_name     = "${var.resource_group_name}"
  loadbalancer_id         = "${azurerm_lb.proxy_lb.id}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.api-proxy-lb.id}"
  probe_id                = "${azurerm_lb_probe.api-proxy-lb.id}"

  protocol                       = "tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "api-proxy"
}

resource "azurerm_lb_probe" "api-proxy-lb" {
  name                = "api-proxy-lb-probe-443-up"
  loadbalancer_id     = "${azurerm_lb.proxy_lb.id}"
  resource_group_name = "${var.resource_group_name}"
  protocol            = "tcp"
  port                = 443
}

data "template_file" "scripts_nsupdate" {
  template = <<EOF
update delete $${cluster_name}.$${base_domain} A
update delete $${cluster_name}-api.$${base_domain} A
update delete $${cluster_name}-master.$${base_domain} A

update add $${cluster_name}.$${base_domain} 0 A $${console_ip_address}
update add $${cluster_name}-api.$${base_domain} 0 A $${api_proxy_ip_address}
update add $${cluster_name}-master.$${base_domain} 0 A $${ip_address}

send
EOF

  vars {
    cluster_name = "${var.cluster_name}"
    base_domain  = "${var.base_domain}"

    ip_address           = "${azurerm_lb.tectonic_lb.frontend_ip_configuration.0.private_ip_address}"
    console_ip_address   = "${azurerm_lb.tectonic_lb.frontend_ip_configuration.1.private_ip_address}"
    api_proxy_ip_address = "${azurerm_lb.proxy_lb.frontend_ip_configuration.0.private_ip_address}"
  }
}

resource "local_file" "nsupdate" {
  content  = "${data.template_file.scripts_nsupdate.rendered}"
  filename = "${path.cwd}/generated/dns/k8s-dns.txt"
}

resource "null_resource" "scripts_nsupdate" {
  depends_on = ["local_file.nsupdate"]

  triggers {
    md5 = "${md5(data.template_file.scripts_nsupdate.rendered)}"
  }

  provisioner "local-exec" {
    command = "nsupdate -d ${path.cwd}/generated/dns/k8s-dns.txt"
  }
}
