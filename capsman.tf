resource "routeros_caps_man_datapath" "bridge_lan" {
  count = var.enable_capsman ? 1 : 0

  name    = "capsman_lan"
  bridge  = routeros_interface_bridge.lan.name
  comment = "CAPsMAN datapath on LAN bridge"
}

resource "routeros_caps_man_security" "wpa2_home" {
  count = var.enable_capsman ? 1 : 0

  name                 = "wpa2_home"
  authentication_types = "wpa2-psk"
  encryption           = "aes-ccm"
  passphrase           = var.wifi_passphrase
  comment              = "WPA2 security profile for home Wi-Fi"
}

resource "routeros_caps_man_configuration" "wifi_home" {
  count = var.enable_capsman ? 1 : 0

  name     = "wifi_home"
  ssid     = var.wifi_ssid
  mode     = "ap"
  datapath = routeros_caps_man_datapath.bridge_lan[0].name
  security = routeros_caps_man_security.wpa2_home[0].name
  country  = "us"
  channel  = "2412/20-Ce/gn"
  comment  = "Main Wi-Fi profile for CAPsMAN"
}

resource "routeros_caps_man_provision" "default" {
  count = var.enable_capsman ? 1 : 0

  action        = "create-enabled"
  master_config = routeros_caps_man_configuration.wifi_home[0].name
  common_name   = ""
  comment       = "Auto-provision all CAPs"
}

resource "routeros_caps_man_manager" "enable_manager" {
  count = var.enable_capsman ? 1 : 0

  enabled                  = true
  interfaces               = [routeros_interface_bridge.lan.name]
  require_peer_certificate = false
  comment                  = "CAPsMAN controller on bridge_lan"
}
