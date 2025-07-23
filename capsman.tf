resource "routeros_capsman_datapath" "bridge_lan" {
  count = var.enable_capsman ? 1 : 0

  name    = "capsman_lan"
  bridge  = routeros_interface_bridge.lan.name
  comment = "CAPsMAN datapath on LAN bridge"
}

resource "routeros_capsman_security" "wpa2_home" {
  count = var.enable_capsman ? 1 : 0

  name                 = "wpa2_home"
  authentication_types = ["wpa2-psk"]
  encryption           = ["aes-ccm"]
  passphrase           = var.wifi_passphrase
  comment              = "WPA2 security profile for home Wi-Fi"
}

resource "routeros_capsman_configuration" "wifi_home_2ghz" {
  count = var.enable_capsman ? 1 : 0

  name     = "${var.wifi_ssid}_2ghz"
  ssid     = var.wifi_ssid
  mode     = "ap"
  datapath = {
    name = routeros_capsman_datapath.bridge_lan[0].name
  }
  security = {
    name = routeros_capsman_security.wpa2_home[0].name
  }
  country  = var.wifi_country
  channel  = var.wifi_channel
  comment  = "2.4GHz Wi-Fi profile for CAPsMAN"
}

resource "routeros_capsman_configuration" "wifi_home_5ghz" {
  count = var.enable_capsman && var.enable_5ghz ? 1 : 0

  name     = "${var.wifi_ssid}_5ghz"
  ssid     = var.wifi_ssid_5ghz != "" ? var.wifi_ssid_5ghz : var.wifi_ssid
  mode     = "ap"
  datapath = {
    name = routeros_capsman_datapath.bridge_lan[0].name
  }
  security = {
    name = routeros_capsman_security.wpa2_home[0].name
  }
  country  = var.wifi_country
  channel  = var.wifi_channel_5ghz
  comment  = "5GHz Wi-Fi profile for CAPsMAN"
}

resource "routeros_capsman_manager" "enable_manager" {
  count = var.enable_capsman ? 1 : 0

  enabled                  = true
  require_peer_certificate = false
}
