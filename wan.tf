resource "routeros_interface_ethernet" "ether2" {
  name         = var.wan_interface
  factory_name = "ether2"
  comment      = "WAN"
}

resource "routeros_ip_dhcp_client" "wan_dhcp" {
  interface         = routeros_interface_ethernet.ether2.name
  add_default_route = var.wan_add_default_route
  use_peer_dns      = var.wan_use_peer_dns
  use_peer_ntp      = var.wan_use_peer_ntp
  comment           = "WAN DHCP client on ether2"
}

# Accept established connections
resource "routeros_ip_firewall_filter" "accept_established" {
  count            = var.enable_wan_firewall ? 1 : 0
  chain            = "input"
  action           = "accept"
  connection_state = "established"
  comment          = "Accept established connections"
}

# Accept related connections
resource "routeros_ip_firewall_filter" "accept_related" {
  count            = var.enable_wan_firewall ? 1 : 0
  chain            = "input"
  action           = "accept"
  connection_state = "related"
  comment          = "Accept related connections"
}

# Drop invalid packets
resource "routeros_ip_firewall_filter" "drop_invalid" {
  count            = var.enable_wan_firewall ? 1 : 0
  chain            = "input"
  action           = "drop"
  connection_state = "invalid"
  comment          = "Drop invalid packets"
}

# Drop new connections from WAN
resource "routeros_ip_firewall_filter" "drop_wan_in" {
  count            = var.enable_wan_firewall ? 1 : 0
  chain            = "input"
  in_interface     = routeros_interface_ethernet.ether2.name
  connection_state = "new"
  action           = "drop"
  comment          = "Drop unsolicited WAN input"
}
