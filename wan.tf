resource "routeros_interface_ethernet" "ether2" {
  name         = "WAN"
  factory_name = "ether2"
  comment      = "WAN"
}

resource "routeros_ip_dhcp_client" "wan_dhcp" {
  interface         = routeros_interface_ethernet.ether2.name
  add_default_route = "yes" # must be "yes", "no", or "special-classless"
  use_peer_dns      = true
  use_peer_ntp      = false
  comment           = "WAN DHCP client on ether2"
}

# Accept established connections
resource "routeros_ip_firewall_filter" "accept_established" {
  chain            = "input"
  action           = "accept"
  connection_state = "established"
  comment          = "Accept established connections"
}

# Accept related connections
resource "routeros_ip_firewall_filter" "accept_related" {
  chain            = "input"
  action           = "accept"
  connection_state = "related"
  comment          = "Accept related connections"
}

# Drop invalid packets
resource "routeros_ip_firewall_filter" "drop_invalid" {
  chain            = "input"
  action           = "drop"
  connection_state = "invalid"
  comment          = "Drop invalid packets"
}

# Drop new connections from WAN
resource "routeros_ip_firewall_filter" "drop_wan_in" {
  chain            = "input"
  in_interface     = routeros_interface_ethernet.ether2.name
  connection_state = "new"
  action           = "drop"
  comment          = "Drop unsolicited WAN input"
}
