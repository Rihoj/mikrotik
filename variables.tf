# ==============================================
# Connection Variables
# ==============================================

variable "routeros_hosturl" {
  description = "RouterOS API URL (e.g., http://192.168.88.254:8728 or https://192.168.88.254:8729)"
  type        = string
}

variable "routeros_user" {
  description = "RouterOS username for API access"
  type        = string
}

variable "routeros_password" {
  description = "RouterOS password for API access"
  type        = string
  sensitive   = true
}

# ==============================================
# Network Configuration Variables  
# ==============================================

variable "management_subnet" {
  description = "Management network subnet"
  type        = string
  default     = "192.168.88.0/24"
}

variable "management_ip" {
  description = "Management interface IP address"
  type        = string
  default     = "192.168.88.254/24"
}

variable "lan_subnet" {
  description = "LAN network subnet"
  type        = string
  default     = "192.168.1.0/24"
}

variable "lan_gateway" {
  description = "LAN gateway IP address"
  type        = string
  default     = "192.168.1.1/24"
}

variable "dhcp_pool_start" {
  description = "DHCP pool starting IP address"
  type        = string
  default     = "192.168.1.50"
}

variable "dhcp_pool_end" {
  description = "DHCP pool ending IP address"
  type        = string
  default     = "192.168.1.200"
}

variable "dns_servers" {
  description = "DNS servers for DHCP clients"
  type        = list(string)
  default     = ["8.8.8.8", "1.1.1.1"]
}

variable "wifi_subnet" {
  description = "Wi-Fi network subnet"
  type        = string
  default     = "192.168.2.0/24"
}

variable "wifi_gateway" {
  description = "Wi-Fi gateway IP address"
  type        = string
  default     = "192.168.2.1/24"
}

variable "servers_subnet" {
  description = "Servers network subnet"
  type        = string
  default     = "192.168.3.0/24"
}

variable "servers_gateway" {
  description = "Servers gateway IP address"
  type        = string
  default     = "192.168.3.1/24"
}

variable "servers_dhcp_pool_start" {
  description = "Servers DHCP pool starting IP address"
  type        = string
  default     = "192.168.3.50"
}

variable "servers_dhcp_pool_end" {
  description = "Servers DHCP pool ending IP address"
  type        = string
  default     = "192.168.3.200"
}

# ==============================================
# DHCP Configuration Variables
# ==============================================

variable "dhcp_lease_time" {
  description = "DHCP lease time"
  type        = string
  default     = "1h"
}

variable "dhcp_authoritative" {
  description = "DHCP authoritative mode"
  type        = string
  default     = "yes"
  validation {
    condition     = contains(["yes", "no", "after-2sec-delay", "after-10sec-delay"], var.dhcp_authoritative)
    error_message = "dhcp_authoritative must be one of: yes, no, after-2sec-delay, after-10sec-delay"
  }
}

variable "add_arp" {
  description = "Add ARP entries for DHCP leases"
  type        = bool
  default     = true
}

# ==============================================
# WiFi/CAPsMAN Configuration Variables
# ==============================================

variable "enable_capsman" {
  description = "Toggle CAPsMAN wireless management"
  type        = bool
  default     = false
}

variable "wifi_ssid" {
  description = "SSID for the Wi-Fi network"
  type        = string
  default     = "HomeWiFi"
}

variable "wifi_passphrase" {
  description = "Passphrase for the Wi-Fi network"
  type        = string
  default     = "changeme123" # 🔒 replace with secure passphrase
  sensitive   = true
}

variable "wifi_country" {
  description = "WiFi country code for regulatory compliance"
  type        = string
  default     = "us"
}

variable "wifi_channel" {
  description = "WiFi channel configuration for 2.4GHz and 5GHz bands"
  type = object({
    frequency = string
    width     = string
  })
  default = {
    frequency = "2412"  # Channel 1 (2.4GHz) - non-overlapping, good compatibility
    width     = "20"    # 20MHz width for maximum compatibility
  }
}

variable "wifi_channel_5ghz" {
  description = "5GHz WiFi channel configuration"
  type = object({
    frequency = string
    width     = string
  })
  default = {
    frequency = "5180"  # Channel 36 (5GHz UNII-1) - no DFS required
    width     = "80"    # 80MHz width for better performance
  }
}

variable "enable_5ghz" {
  description = "Enable 5GHz WiFi band"
  type        = bool
  default     = true
}

variable "wifi_ssid_5ghz" {
  description = "SSID for the 5GHz Wi-Fi network (if different from 2.4GHz)"
  type        = string
  default     = ""  # Empty string means use same SSID as 2.4GHz
}

# ==============================================
# Interface and Port Configuration
# ==============================================

variable "bridge_name" {
  description = "Name of the main LAN bridge"
  type        = string
  default     = "bridge_lan"
}

variable "wan_interface" {
  description = "WAN interface name"
  type        = string
  default     = "WAN"
}

variable "wan_add_default_route" {
  description = "Add default route via WAN DHCP client"
  type        = string
  default     = "yes"
  validation {
    condition     = contains(["yes", "no", "special-classless"], var.wan_add_default_route)
    error_message = "wan_add_default_route must be one of: yes, no, special-classless"
  }
}

variable "wan_use_peer_dns" {
  description = "Use DNS servers provided by WAN DHCP"
  type        = bool
  default     = true
}

variable "wan_use_peer_ntp" {
  description = "Use NTP servers provided by WAN DHCP"
  type        = bool
  default     = false
}

# ==============================================
# Static IP Assignments
# ==============================================

variable "wifi_ap_ips" {
  description = "Static IP addresses for WiFi Access Points"
  type        = map(string)
  default = {
    main      = "192.168.1.10"
    secondary = "192.168.1.11"
    tertiary  = "192.168.1.12"
  }
}

variable "server_ips" {
  description = "Static IP addresses for servers"
  type        = map(string)
  default = {
    nas      = "192.168.1.40"
    sonic    = "192.168.1.41"
    rhuidean = "192.168.1.42"
  }
}

variable "client_ips" {
  description = "Static IP addresses for client devices"
  type        = map(string)
  default = {
    vivint_hub     = "192.168.1.20"
    bytebeast_wifi = "192.168.1.30"
    bytebeast_eth  = "192.168.1.31"
    xbox          = "192.168.1.32"
  }
}

# ==============================================
# Security and Firewall Variables
# ==============================================

variable "enable_wan_firewall" {
  description = "Enable WAN firewall rules"
  type        = bool
  default     = true
}

variable "enable_management_firewall" {
  description = "Enable management interface firewall protection"
  type        = bool
  default     = true
}

# ==============================================
# Optional Feature Toggles
# ==============================================

variable "enable_subnet_routing" {
  description = "Enable routing between management and LAN subnets"
  type        = bool
  default     = true
}

variable "enable_dhcp_server" {
  description = "Enable DHCP server on LAN"
  type        = bool
  default     = true
}