output "ip_address" {
  value = ["${azurerm_lb.tectonic_etcd_lb.frontend_ip_configuration.0.private_ip_address}"]
}

#output "lb_ip" {
#  value = "${azurerm_public_ip.etcd_publicip.ip_address}"
#}

