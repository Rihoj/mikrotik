resource "routeros_ip_route" "mgmt_default_gateway" {
  count       = var.enable_subnet_routing ? 1 : 0
  dst_address = "0.0.0.0/0"
  gateway     = split("/", var.lan_gateway)[0]
  comment     = "Default gateway for management network"
}

resource "routeros_ip_firewall_nat" "masquerade_mgmt" {
  count         = var.enable_subnet_routing ? 1 : 0
  chain         = "srcnat"
  action        = "masquerade"
  out_interface = routeros_interface_ethernet.ether2.name
  comment       = "Masquerade management network to WAN"
}

resource "routeros_ip_firewall_filter" "allow_mgmt_to_lan" {
  count       = var.enable_subnet_routing ? 1 : 0
  chain       = "forward"
  action      = "accept"
  src_address = var.management_subnet
  dst_address = var.lan_subnet
  comment     = "Allow management network to access LAN"
}

resource "routeros_ip_firewall_filter" "allow_lan_to_mgmt" {
  count       = var.enable_subnet_routing ? 1 : 0
  chain       = "forward"
  action      = "accept"
  src_address = var.lan_subnet
  dst_address = var.management_subnet
  comment     = "Allow LAN access to management network"
}

resource "routeros_ip_firewall_filter" "block_internet_to_mgmt" {
  count            = var.enable_subnet_routing ? 1 : 0
  chain            = "input"
  action           = "drop"
  in_interface     = routeros_interface_ethernet.ether2.name
  dst_address      = split("/", var.management_ip)[0]
  connection_state = "new"
  comment          = "Block internet access to management network"
}

resource "routeros_ip_firewall_filter" "allow_established_mgmt" {
  count            = var.enable_subnet_routing ? 1 : 0
  chain            = "forward"
  action           = "accept"
  connection_state = "established"
  comment          = "Allow established connections for management network"
}

resource "routeros_ip_firewall_filter" "allow_related_established_mgmt" {
  count            = var.enable_subnet_routing ? 1 : 0
  chain            = "forward"
  action           = "accept"
  connection_state = "related"
  comment          = "Allow related connections for management network"
}