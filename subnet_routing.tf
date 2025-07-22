resource "routeros_ip_route" "mgmt_default_gateway" {
  dst_address = "0.0.0.0/0"
  gateway     = "192.168.1.1"
  comment     = "Default gateway for management network"
}

resource "routeros_ip_firewall_nat" "masquerade_mgmt" {
  chain         = "srcnat"
  action        = "masquerade"
  out_interface = routeros_interface_ethernet.ether2.name
  comment       = "Masquerade management network to WAN"
}

resource "routeros_ip_firewall_filter" "allow_mgmt_to_lan" {
  chain       = "forward"
  action      = "accept"
  src_address = "192.168.88.0/24"
  dst_address = "192.168.1.0/24"
  comment     = "Allow management network to access LAN"
}

resource "routeros_ip_firewall_filter" "allow_lan_to_mgmt" {
  chain       = "forward"
  action      = "accept"
  src_address = "192.168.1.0/24"
  dst_address = "192.168.88.0/24"
  comment     = "Allow LAN access to management network"
}

resource "routeros_ip_firewall_filter" "block_internet_to_mgmt" {
  chain            = "input"
  action           = "drop"
  in_interface     = routeros_interface_ethernet.ether2.name
  dst_address      = "192.168.88.254"
  connection_state = "new"
  comment          = "Block internet access to management network"
}

resource "routeros_ip_firewall_filter" "allow_established_mgmt" {
  chain            = "forward"
  action           = "accept"
  connection_state = "established"
  comment          = "Allow established connections for management network"
}
resource "routeros_ip_firewall_filter" "allow_related_established_mgmt" {
  chain            = "forward"
  action           = "accept"
  connection_state = "related"
  comment          = "Allow related connections for management network"
}