resource "azurerm_lb" "tectonic_lb" {
  name                = "api-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration {
    name = "api"

    subnet_id                     = "${var.subnet}"
    private_ip_address_allocation = "dynamic"
  }

  frontend_ip_configuration {
    name = "console"

    subnet_id                     = "${var.subnet}"
    private_ip_address_allocation = "dynamic"
  }
}

data "template_file" "scripts_nsupdate" {
  template = <<EOF
update delete $${cluster_name}.$${base_domain} A
update delete $${cluster_name}-k8s.$${base_domain} A
update delete $${cluster_name}-master.$${base_domain} A

update add $${cluster_name}.$${base_domain} 0 A $${console_ip_address}
update add $${cluster_name}-k8s.$${base_domain} 0 A $${api_proxy_ip_address}
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
