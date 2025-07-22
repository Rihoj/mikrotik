variable "routeros_hosturl" {}
variable "routeros_user" {}
variable "routeros_password" {}
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
}