##########################
# Management Port Config #
##########################

# Set static IP on ether1
resource "routeros_ip_address" "mgmt" {
  address   = var.management_ip
  interface = routeros_interface_ethernet.ether1.name
  comment   = "Management interface IP"
}

# Add a label to ether1 for clarity
resource "routeros_interface_ethernet" "ether1" {
  name         = "mgmt"
  factory_name = "ether1"
  comment      = "mgmt"
}

#####################################
# Firewall Input Rules - Fail Safes #
#####################################

# 1. Accept all traffic *from* mgmt subnet via ether1
resource "routeros_ip_firewall_filter" "allow_mgmt_in" {
  count        = var.enable_management_firewall ? 1 : 0
  chain        = "input"
  action       = "accept"
  src_address  = var.management_subnet
  in_interface = routeros_interface_ethernet.ether1.name
  comment      = "Allow management subnet access via ether1"
}

# 2. Accept all traffic to router sourced from ether1 (hard fail-safe)
resource "routeros_ip_firewall_filter" "allow_mgmt_interface_all" {
  count        = var.enable_management_firewall ? 1 : 0
  chain        = "input"
  action       = "accept"
  in_interface = routeros_interface_ethernet.ether1.name
  comment      = "Fail-safe: Allow all traffic via ether1"
  disabled     = false
}

# 3. OPTIONAL: Add a rule that drops everything else at the bottom
# Only use this if you are sure mgmt rules are above it!
resource "routeros_ip_firewall_filter" "drop_all_else" {
  count    = var.enable_management_firewall ? 1 : 0
  chain    = "input"
  action   = "drop"
  comment  = "Drop all other input traffic (keep this last!)"
  disabled = true # Start with this rule disabled for safety
}

resource "routeros_ip_firewall_filter" "allow_ssh_winbox" {
  count        = var.enable_management_firewall ? 1 : 0
  chain        = "input"
  action       = "accept"
  in_interface = routeros_interface_ethernet.ether1.name
  protocol     = "tcp"
  dst_port     = "22,8291"
  comment      = "Allow SSH and WinBox on mgmt"
}
