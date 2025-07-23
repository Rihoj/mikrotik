# ==============================================
# Subnet Routing and Firewall Rules
# ==============================================
# This file configures routing and firewall rules between subnets:
# - LAN, Wi-Fi, and Servers can communicate with each other
# - Management can communicate with all subnets
# - Only LAN can reach Management subnet
# - All subnets can access internet (WAN)

# ==============================================
# Default Gateway Routes
# ==============================================

resource "routeros_ip_route" "mgmt_default_gateway" {
  count       = var.enable_subnet_routing ? 1 : 0
  dst_address = "0.0.0.0/0"
  gateway     = split("/", var.lan_gateway)[0]
  comment     = "Default gateway for management network"
}

# ==============================================
# NAT Rules for Internet Access
# ==============================================

# Note: Basic masquerade rule exists in lan.tf
# These are subnet-specific NAT rules for additional control

resource "routeros_ip_firewall_nat" "masquerade_wifi" {
  count         = var.enable_subnet_routing ? 1 : 0
  chain         = "srcnat"
  action        = "masquerade"
  src_address   = var.wifi_subnet
  out_interface = routeros_interface_ethernet.ether2.name
  comment       = "Masquerade Wi-Fi network to WAN"
}

resource "routeros_ip_firewall_nat" "masquerade_servers" {
  count         = var.enable_subnet_routing ? 1 : 0
  chain         = "srcnat"
  action        = "masquerade"
  src_address   = var.servers_subnet
  out_interface = routeros_interface_ethernet.ether2.name
  comment       = "Masquerade Servers network to WAN"
}

resource "routeros_ip_firewall_nat" "masquerade_mgmt" {
  count         = var.enable_subnet_routing ? 1 : 0
  chain         = "srcnat"
  action        = "masquerade"
  src_address   = var.management_subnet
  out_interface = routeros_interface_ethernet.ether2.name
  comment       = "Masquerade management network to WAN"
}

# ==============================================
# Inter-Subnet Communication Rules
# ==============================================

# Allow established and related connections (place early for efficiency)
resource "routeros_ip_firewall_filter" "allow_established" {
  count            = var.enable_subnet_routing ? 1 : 0
  chain            = "forward"
  action           = "accept"
  connection_state = "established,related"
  comment          = "Allow established and related connections"
}

# Management to all subnets (management can reach everything)
resource "routeros_ip_firewall_filter" "allow_mgmt_to_lan" {
  count       = var.enable_subnet_routing ? 1 : 0
  chain       = "forward"
  action      = "accept"
  src_address = var.management_subnet
  dst_address = var.lan_subnet
  comment     = "Allow management network to access LAN"
}

resource "routeros_ip_firewall_filter" "allow_mgmt_to_wifi" {
  count       = var.enable_subnet_routing ? 1 : 0
  chain       = "forward"
  action      = "accept"
  src_address = var.management_subnet
  dst_address = var.wifi_subnet
  comment     = "Allow management network to access Wi-Fi"
}

resource "routeros_ip_firewall_filter" "allow_mgmt_to_servers" {
  count       = var.enable_subnet_routing ? 1 : 0
  chain       = "forward"
  action      = "accept"
  src_address = var.management_subnet
  dst_address = var.servers_subnet
  comment     = "Allow management network to access Servers"
}

# LAN to Management (only LAN can reach management)
resource "routeros_ip_firewall_filter" "allow_lan_to_mgmt" {
  count       = var.enable_subnet_routing ? 1 : 0
  chain       = "forward"
  action      = "accept"
  src_address = var.lan_subnet
  dst_address = var.management_subnet
  comment     = "Allow LAN access to management network"
}

# LAN, Wi-Fi, and Servers can communicate with each other
resource "routeros_ip_firewall_filter" "allow_lan_to_wifi" {
  count       = var.enable_subnet_routing ? 1 : 0
  chain       = "forward"
  action      = "accept"
  src_address = var.lan_subnet
  dst_address = var.wifi_subnet
  comment     = "Allow LAN to Wi-Fi communication"
}

resource "routeros_ip_firewall_filter" "allow_lan_to_servers" {
  count       = var.enable_subnet_routing ? 1 : 0
  chain       = "forward"
  action      = "accept"
  src_address = var.lan_subnet
  dst_address = var.servers_subnet
  comment     = "Allow LAN to Servers communication"
}

resource "routeros_ip_firewall_filter" "allow_wifi_to_lan" {
  count       = var.enable_subnet_routing ? 1 : 0
  chain       = "forward"
  action      = "accept"
  src_address = var.wifi_subnet
  dst_address = var.lan_subnet
  comment     = "Allow Wi-Fi to LAN communication"
}

resource "routeros_ip_firewall_filter" "allow_wifi_to_servers" {
  count       = var.enable_subnet_routing ? 1 : 0
  chain       = "forward"
  action      = "accept"
  src_address = var.wifi_subnet
  dst_address = var.servers_subnet
  comment     = "Allow Wi-Fi to Servers communication"
}

resource "routeros_ip_firewall_filter" "allow_servers_to_lan" {
  count       = var.enable_subnet_routing ? 1 : 0
  chain       = "forward"
  action      = "accept"
  src_address = var.servers_subnet
  dst_address = var.lan_subnet
  comment     = "Allow Servers to LAN communication"
}

resource "routeros_ip_firewall_filter" "allow_servers_to_wifi" {
  count       = var.enable_subnet_routing ? 1 : 0
  chain       = "forward"
  action      = "accept"
  src_address = var.servers_subnet
  dst_address = var.wifi_subnet
  comment     = "Allow Servers to Wi-Fi communication"
}

# ==============================================
# Block Rules (denying unauthorized access)
# ==============================================

# Block Wi-Fi and Servers from accessing Management
resource "routeros_ip_firewall_filter" "block_wifi_to_mgmt" {
  count       = var.enable_subnet_routing ? 1 : 0
  chain       = "forward"
  action      = "drop"
  src_address = var.wifi_subnet
  dst_address = var.management_subnet
  comment     = "Block Wi-Fi access to management network"
}

resource "routeros_ip_firewall_filter" "block_servers_to_mgmt" {
  count       = var.enable_subnet_routing ? 1 : 0
  chain       = "forward"
  action      = "drop"
  src_address = var.servers_subnet
  dst_address = var.management_subnet
  comment     = "Block Servers access to management network"
}

# Block internet access to management network
resource "routeros_ip_firewall_filter" "block_internet_to_mgmt" {
  count            = var.enable_subnet_routing ? 1 : 0
  chain            = "input"
  action           = "drop"
  in_interface     = routeros_interface_ethernet.ether2.name
  dst_address      = split("/", var.management_ip)[0]
  connection_state = "new"
  comment          = "Block internet access to management network"
}