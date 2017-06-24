## Workaround for https://github.com/coreos/tectonic-installer/issues/657
## Related to: https://github.com/Microsoft/azure-docs/blob/master/articles/load-balancer/load-balancer-internal-overview.md#limitations

resource "azurerm_lb" "proxy_lb" {
  name                = "${var.cluster_name}-console-proxy-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration {
    name                          = "console-proxy"
    subnet_id                     = "${var.subnet}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "console-proxy-lb" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.proxy_lb.id}"
  name                = "console-proxy-lb-pool"
}

resource "azurerm_lb_rule" "console-proxy-lb-https" {
  name                    = "console-proxy-lb-rule-443-443"
  resource_group_name     = "${var.resource_group_name}"
  loadbalancer_id         = "${azurerm_lb.proxy_lb.id}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.console-proxy-lb.id}"
  probe_id                = "${azurerm_lb_probe.console-proxy-lb-https.id}"

  protocol                       = "tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "console-proxy"
}

resource "azurerm_lb_probe" "console-proxy-lb-https" {
  name                = "console-proxy-lb-probe-443-up"
  loadbalancer_id     = "${azurerm_lb.proxy_lb.id}"
  resource_group_name = "${var.resource_group_name}"
  protocol            = "tcp"
  port                = 443
}

resource "azurerm_lb_rule" "console-proxy-lb-http" {
  name                    = "console-proxy-lb-rule-80-80"
  resource_group_name     = "${var.resource_group_name}"
  loadbalancer_id         = "${azurerm_lb.proxy_lb.id}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.console-proxy-lb.id}"
  probe_id                = "${azurerm_lb_probe.console-proxy-lb-http.id}"

  protocol                       = "tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "console-proxy"
}

resource "azurerm_lb_probe" "console-proxy-lb-http" {
  name                = "console-proxy-lb-probe-80-up"
  loadbalancer_id     = "${azurerm_lb.proxy_lb.id}"
  resource_group_name = "${var.resource_group_name}"
  protocol            = "tcp"
  port                = 80
}

data "template_file" "scripts_nsupdate" {
  template = <<EOF
update delete $${cluster_name}.$${base_domain} A
update add $${cluster_name}.$${base_domain} 0 A $${console_proxy_lb_ip_address}

send
EOF

  vars {
    cluster_name                = "${var.cluster_name}"
    base_domain                 = "${var.base_domain}"
    console_proxy_lb_ip_address = "${azurerm_lb.proxy_lb.frontend_ip_configuration.0.private_ip_address}"
  }
}

resource "local_file" "nsupdate" {
  content  = "${data.template_file.scripts_nsupdate.rendered}"
  filename = "${path.cwd}/generated/dns/console-dns.txt.txt"
}

resource "null_resource" "scripts_nsupdate" {
  depends_on = ["local_file.nsupdate"]

  triggers {
    md5 = "${md5(data.template_file.scripts_nsupdate.rendered)}"
  }

  provisioner "local-exec" {
    command = "nsupdate -d ${path.cwd}/generated/dns/console-dns.txt.txt"
  }
}
