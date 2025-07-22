resource "routeros_interface_ethernet" "ether3" {
  factory_name = "ether3"
  name         = "ether3"
  comment      = "WiFi AP - Main Access Point"
}

import {
  to = routeros_interface_ethernet.ether3
  id = "*4"
}

resource "routeros_interface_ethernet" "ether4" {
  factory_name = "ether4"
  name         = "ether4"
  comment      = "WiFi AP - Secondary/Mesh"
}

import {
  to = routeros_interface_ethernet.ether4
  id = "*5"
}

resource "routeros_interface_ethernet" "ether5" {
  factory_name = "ether5"
  name         = "ether5"
  comment      = "WiFi AP - Tertiary/Mesh"
}

import {
  to = routeros_interface_ethernet.ether5
  id = "*6"
}

resource "routeros_interface_ethernet" "ether6" {
  factory_name = "ether6"
  name         = "ether6"
  comment      = "NAS"
}

import {
  to = routeros_interface_ethernet.ether6
  id = "*7"
}

resource "routeros_interface_ethernet" "ether7" {
  factory_name = "ether7"
  name         = "ether7"
  comment      = "Sonic"
}

import {
  to = routeros_interface_ethernet.ether7
  id = "*8"
}

resource "routeros_interface_ethernet" "ether8" {
  factory_name = "ether8"
  name         = "ether8"
  comment      = "Rhuidean"
}

import {
  to = routeros_interface_ethernet.ether8
  id = "*9"
}

resource "routeros_interface_ethernet" "ether9" {
  factory_name = "ether9"
  name         = "ether9"
  comment      = "LAN - Spare/General Purpose"
}

import {
  to = routeros_interface_ethernet.ether9
  id = "*A"
}

resource "routeros_interface_ethernet" "ether10" {
  factory_name = "ether10"
  name         = "ether10"
  comment      = "LAN - Spare/General Purpose"
}

import {
  to = routeros_interface_ethernet.ether10
  id = "*B"
}

resource "routeros_interface_ethernet" "ether11" {
  factory_name = "ether11"
  name         = "ether11"
  comment      = "LAN - Spare/General Purpose"
}

import {
  to = routeros_interface_ethernet.ether11
  id = "*C"
}

resource "routeros_interface_ethernet" "ether12" {
  factory_name = "ether12"
  name         = "ether12"
  comment      = "LAN - Spare/General Purpose"
}

import {
  to = routeros_interface_ethernet.ether12
  id = "*D"
}

resource "routeros_interface_ethernet" "ether13" {
  factory_name = "ether13"
  name         = "ether13"
  comment      = "LAN - Spare/General Purpose"
}

import {
  to = routeros_interface_ethernet.ether13
  id = "*E"
}

resource "routeros_interface_ethernet" "ether14" {
  factory_name = "ether14"
  name         = "ether14"
  comment      = "LAN - Spare/General Purpose"
}

import {
  to = routeros_interface_ethernet.ether14
  id = "*F"
}

resource "routeros_interface_ethernet" "ether15" {
  factory_name = "ether15"
  name         = "ether15"
  comment      = "LAN - Spare/General Purpose"
}

import {
  to = routeros_interface_ethernet.ether15
  id = "*10"
}

resource "routeros_interface_ethernet" "ether16" {
  factory_name = "ether16"
  name         = "ether16"
  comment      = "LAN - Spare/General Purpose"
}

import {
  to = routeros_interface_ethernet.ether16
  id = "*11"
}

resource "routeros_interface_ethernet" "ether17" {
  factory_name = "ether17"
  name         = "ether17"
  comment      = "LAN - Spare/General Purpose"
}

import {
  to = routeros_interface_ethernet.ether17
  id = "*12"
}

resource "routeros_interface_ethernet" "ether18" {
  factory_name = "ether18"
  name         = "ether18"
  comment      = "LAN - Spare/General Purpose"
}

import {
  to = routeros_interface_ethernet.ether18
  id = "*13"
}

resource "routeros_interface_ethernet" "ether19" {
  factory_name = "ether19"
  name         = "ether19"
  comment      = "LAN - Spare/General Purpose"
}

import {
  to = routeros_interface_ethernet.ether19
  id = "*14"
}

resource "routeros_interface_ethernet" "ether20" {
  factory_name = "ether20"
  name         = "ether20"
  comment      = "LAN - Spare/General Purpose"
}

import {
  to = routeros_interface_ethernet.ether20
  id = "*15"
}

resource "routeros_interface_ethernet" "ether21" {
  factory_name = "ether21"
  name         = "ether21"
  comment      = "LAN - Spare/General Purpose"
}

import {
  to = routeros_interface_ethernet.ether21
  id = "*16"
}

resource "routeros_interface_ethernet" "ether22" {
  factory_name = "ether22"
  name         = "ether22"
  comment      = "LAN - Spare/General Purpose"
}

import {
  to = routeros_interface_ethernet.ether22
  id = "*17"
}

resource "routeros_interface_ethernet" "ether23" {
  factory_name = "ether23"
  name         = "ether23"
  comment      = "LAN - Spare/General Purpose"
}

import {
  to = routeros_interface_ethernet.ether23
  id = "*18"
}

resource "routeros_interface_ethernet" "ether24" {
  factory_name = "ether24"
  name         = "ether24"
  comment      = "LAN - Spare/General Purpose"
}

import {
  to = routeros_interface_ethernet.ether24
  id = "*19"
}

