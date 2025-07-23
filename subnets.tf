# ==============================================
# Subnet Configuration
# ==============================================
# This file configures the segmented subnets:
# - LAN (192.168.1.0/24) - Wired devices
# - Wi-Fi (192.168.2.0/24) - Wireless devices
# - Servers (192.168.3.0/24) - Server infrastructure
# - Management (192.168.88.0/24) - Management network

# ==============================================
# IP Pools for each subnet
# ==============================================

# LAN Pool (already exists in lan.tf but we'll keep it there)

resource "routeros_ip_pool" "wifi_pool" {
  name   = "wifi_pool"
  ranges = ["192.168.2.50-192.168.2.200"]
}

resource "routeros_ip_pool" "servers_pool" {
  name   = "servers_pool"
  ranges = ["${var.servers_dhcp_pool_start}-${var.servers_dhcp_pool_end}"]
}

resource "routeros_ip_pool" "management_pool" {
  name   = "management_pool"
  ranges = ["192.168.88.50-192.168.88.200"]
}

# ==============================================
# Bridge Interfaces for each subnet
# ==============================================

# Wi-Fi Bridge
resource "routeros_interface_bridge" "wifi" {
  name    = "bridge-wifi"
  comment = "Wi-Fi network bridge"
}

# Servers Bridge
resource "routeros_interface_bridge" "servers" {
  name    = "bridge-servers"
  comment = "Servers network bridge"
}

# ==============================================
# IP Addresses for Gateway Interfaces
# ==============================================

resource "routeros_ip_address" "wifi_gateway" {
  address   = var.wifi_gateway
  interface = routeros_interface_bridge.wifi.name
  comment   = "Wi-Fi bridge gateway IP"
}

resource "routeros_ip_address" "servers_gateway" {
  address   = var.servers_gateway
  interface = routeros_interface_bridge.servers.name
  comment   = "Servers bridge gateway IP"
}

# ==============================================
# DHCP Networks Configuration
# ==============================================

# Wi-Fi DHCP Network (pool created but no DHCP server as requested)
resource "routeros_ip_dhcp_server_network" "wifi_net" {
  address    = var.wifi_subnet
  gateway    = split("/", var.wifi_gateway)[0]
  dns_server = var.dns_servers
  comment    = "Wi-Fi DHCP network configuration"
}

# Servers DHCP Network
resource "routeros_ip_dhcp_server_network" "servers_net" {
  address    = var.servers_subnet
  gateway    = split("/", var.servers_gateway)[0]
  dns_server = var.dns_servers
  comment    = "Servers DHCP network"
}

# Management DHCP Network
resource "routeros_ip_dhcp_server_network" "management_net" {
  address    = var.management_subnet
  gateway    = split("/", var.management_ip)[0]
  dns_server = var.dns_servers
  comment    = "Management DHCP network"
}

# ==============================================
# DHCP Servers (skip Wi-Fi as requested)
# ==============================================

# Servers DHCP Server
resource "routeros_ip_dhcp_server" "servers_dhcp" {
  count         = var.enable_dhcp_server ? 1 : 0
  name          = "dhcp_servers"
  interface     = routeros_interface_bridge.servers.name
  address_pool  = routeros_ip_pool.servers_pool.name
  add_arp       = var.add_arp
  lease_time    = var.dhcp_lease_time
  authoritative = var.dhcp_authoritative
  comment       = "DHCP server for Servers subnet"
}

# Management DHCP Server (optional, usually managed statically)
resource "routeros_ip_dhcp_server" "management_dhcp" {
  count         = var.enable_dhcp_server ? 1 : 0
  name          = "dhcp_management"
  interface     = routeros_interface_ethernet.ether1.name
  address_pool  = routeros_ip_pool.management_pool.name
  add_arp       = var.add_arp
  lease_time    = var.dhcp_lease_time
  authoritative = var.dhcp_authoritative
  comment       = "DHCP server for Management subnet"
}
