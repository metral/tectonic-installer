output "ip_address" {
  value = ["${azurerm_lb.tectonic_lb.frontend_ip_configuration.0.private_ip_address}"]
}

output "console_ip_address" {
  value = "${azurerm_lb.tectonic_lb.frontend_ip_configuration.1.private_ip_address}"
}

output "ingress_external_fqdn" {
  value = "${var.cluster_name}.${var.base_domain}"
}

output "ingress_internal_fqdn" {
  value = "${var.cluster_name}.${var.base_domain}"
}

output "api_external_fqdn" {
  value = "${var.cluster_name}-api.${var.base_domain}"
}

output "api_internal_fqdn" {
  value = "${var.cluster_name}-api.${var.base_domain}"
}

output "private_ip_addresses" {
  value = ["${azurerm_network_interface.tectonic_master.*.private_ip_address}"]
}
