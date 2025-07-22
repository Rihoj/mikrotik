resource "routeros_interface_bridge" "lan" {
  name    = "bridge_lan"
  comment = "Unified bridge for all devices - WiFi, SmartHome, and LAN"
}

resource "routeros_interface_bridge_port" "lan_ports" {
  for_each = toset([
    routeros_interface_ethernet.ether3.name, routeros_interface_ethernet.ether4.name,
    routeros_interface_ethernet.ether5.name, routeros_interface_ethernet.ether6.name,
    routeros_interface_ethernet.ether7.name, routeros_interface_ethernet.ether8.name,
    routeros_interface_ethernet.ether9.name, routeros_interface_ethernet.ether10.name,
    routeros_interface_ethernet.ether11.name, routeros_interface_ethernet.ether12.name,
    routeros_interface_ethernet.ether13.name, routeros_interface_ethernet.ether14.name,
    routeros_interface_ethernet.ether15.name, routeros_interface_ethernet.ether16.name,
    routeros_interface_ethernet.ether17.name, routeros_interface_ethernet.ether18.name,
    routeros_interface_ethernet.ether19.name, routeros_interface_ethernet.ether20.name,
    routeros_interface_ethernet.ether21.name, routeros_interface_ethernet.ether22.name,
    routeros_interface_ethernet.ether23.name, routeros_interface_ethernet.ether24.name
  ])
  bridge    = routeros_interface_bridge.lan.name
  interface = each.value
}

resource "routeros_ip_address" "lan_gateway" {
  address   = "192.168.1.1/24"
  interface = routeros_interface_bridge.lan.name
  comment   = "LAN bridge gateway IP"
}

resource "routeros_ip_pool" "lan_pool" {
  name   = "lan_pool"
  ranges = ["192.168.1.50-192.168.1.200"] # Reserve 192.168.1.1-49 for static assignments
}

resource "routeros_ip_dhcp_server_network" "lan_net" {
  address = "192.168.1.0/24"
  gateway = "192.168.1.1"
  dns_server = [
    "8.8.8.8",
    "1.1.1.1",
  ]
  comment = "LAN DHCP network"
}

resource "routeros_ip_dhcp_server" "lan_dhcp" {
  name          = "dhcp_lan"
  interface     = routeros_interface_bridge.lan.name
  address_pool  = routeros_ip_pool.lan_pool.name
  add_arp       = true
  lease_time    = "1h"
  authoritative = "yes"
  comment       = "DHCP server for LAN"
}

resource "routeros_ip_firewall_nat" "masquerade_lan" {
  chain         = "srcnat"
  action        = "masquerade"
  out_interface = routeros_interface_ethernet.ether2.name
  comment       = "Masquerade LAN to WAN"
}

# DHCP Static Leases for Device Organization
# WiFi Infrastructure
resource "routeros_ip_dhcp_server_lease" "wifi_ap_main" {
  address = "192.168.1.10"
  # mac_address = "14:55:B9:44:96:20"  # Update with actual MAC
  mac_address = "14:55:B9:44:96:24" # Update with actual MAC
  comment     = "WiFi-AP-Main"
  server      = routeros_ip_dhcp_server.lan_dhcp.name
}

resource "routeros_ip_dhcp_server_lease" "wifi_ap_secondary" {
  address     = "192.168.1.11"
  mac_address = "00:00:00:00:00:02" # Update with actual MAC
  comment     = "WiFi-AP-Secondary"
  server      = routeros_ip_dhcp_server.lan_dhcp.name
}

resource "routeros_ip_dhcp_server_lease" "wifi_ap_terciary" {
  address     = "192.168.1.12"
  mac_address = "00:00:00:00:00:03" # Update with actual MAC
  comment     = "WiFi-AP-Terciary"
  server      = routeros_ip_dhcp_server.lan_dhcp.name
}

# SmartHome Wired Infrastructure (IoT devices connect via WiFi)
resource "routeros_ip_dhcp_server_lease" "vivint_smarthub" {
  address     = "192.168.1.20"
  mac_address = "84:eb:3f:0b:19:6e" # Update with actual MAC
  comment     = "VivintSmarthub-0B196D"
  server      = routeros_ip_dhcp_server.lan_dhcp.name
}

# LAN Infrastructure
resource "routeros_ip_dhcp_server_lease" "bytebeast_wifi" {
  address     = "192.168.1.30"
  mac_address = "B8:9A:2A:72:C9:87" # Update with actual MAC
  comment     = "ByteBeast Wifi"
  server      = routeros_ip_dhcp_server.lan_dhcp.name
}

resource "routeros_ip_dhcp_server_lease" "bytebeast_ether" {
  address     = "192.168.1.31"
  mac_address = "80:FA:5B:83:90:70" # Update with actual MAC
  comment     = "ByteBeast Ether"
  server      = routeros_ip_dhcp_server.lan_dhcp.name
}

resource "routeros_ip_dhcp_server_lease" "xbox" {
  address     = "192.168.1.32"
  mac_address = "00:00:00:00:00:07" # Update with actual MAC
  comment     = "LAN-XBox"
  server      = routeros_ip_dhcp_server.lan_dhcp.name
}

# Server Lans
resource "routeros_ip_dhcp_server_lease" "server_nas" {
  address     = "192.168.1.40"
  mac_address = "00:00:00:00:00:09" # Update with actual MAC
  comment     = "LAN-Server-NAS"
  server      = routeros_ip_dhcp_server.lan_dhcp.name
}

## Sonic
resource "routeros_ip_dhcp_server_lease" "sonic" {
  address     = "192.168.1.41"
  mac_address = "00:00:00:00:00:0A" # Update with actual MAC
  comment     = "LAN-Sonic"
  server      = routeros_ip_dhcp_server.lan_dhcp.name
}

## Rhuidean
resource "routeros_ip_dhcp_server_lease" "rhuidean" {
  address     = "192.168.1.42"
  mac_address = "00:00:00:00:00:0B" # Update with actual MAC
  comment     = "LAN-Rhuidean"
  server      = routeros_ip_dhcp_server.lan_dhcp.name
}