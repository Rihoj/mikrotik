# MikroTik Network Configuration Documentation

## Network Overview
- **Single Bridge Architecture**: All devices connect to one unified bridge (`bridge_lan`)
- **Network Subnet**: 192.168.1.0/24
- **Gateway**: 192.168.1.1
- **DHCP Range**: 192.168.1.50-200 (Static leases: 192.168.1.1-49)
- **IoT Architecture**: All IoT/SmartHome devices connect via WiFi (no dedicated IoT controller)

## Port Assignments

### Management & WAN
| Port   | Name | Purpose | IP Address |
|--------|------|---------|------------|
| ether1 | mgmt | Management interface | 192.168.88.254/24 |
| ether2 | WAN  | Internet connection | DHCP Client |

### WiFi Infrastructure
| Port   | Device Type | Purpose | Static IP |
|--------|-------------|---------|-----------|
| ether3 | WiFi AP | Main Access Point | 192.168.1.10 |
| ether4 | WiFi AP | Secondary/Mesh | 192.168.1.11 |
| ether5 | WiFi AP | Tertiary/Mesh | - |

### SmartHome Wired Infrastructure
| Port   | Device Type | Purpose | Static IP |
|--------|-------------|---------|-----------|
| - | Vivint SmartHub | Home security/automation hub | 192.168.1.20 |

### LAN Devices
| Port   | Device Type | Purpose | Static IP |
|--------|-------------|---------|-----------|
| ether6 | NAS | Network Attached Storage | 192.168.1.40 |
| ether7 | Sonic | Server - Sonic | 192.168.1.41 |
| ether8 | Rhuidean | Server - Rhuidean | 192.168.1.42 |
| - | ByteBeast WiFi | Desktop WiFi interface | 192.168.1.30 |
| - | ByteBeast Ethernet | Desktop Ethernet interface | 192.168.1.31 |
| - | Xbox | Gaming Console | 192.168.1.32 |

### Spare/General Purpose Ports
| Port | Purpose |
|------|---------|
| ether9-24 | Spare/General Purpose LAN ports |

## DHCP Static Leases
Static IP assignments are configured for key infrastructure devices to ensure consistent connectivity and easier management:

### Device Categories
- **WiFi Infrastructure**: 192.168.1.10-19 (APs: .10-.11 configured)
- **SmartHome Infrastructure**: 192.168.1.20-29 (Vivint SmartHub: .20)
- **LAN Client Devices**: 192.168.1.30-39 (Desktop & Gaming: .30-.32)
- **Server Infrastructure**: 192.168.1.40-49 (NAS: .40, Sonic: .41, Rhuidean: .42)
- **DHCP Pool**: 192.168.1.50-200

## Security Features
- Management interface on dedicated port (ether1)
- WAN firewall rules (drop unsolicited connections)
- Established/related connection tracking
- NAT masquerading for internet access

## Configuration Notes
1. **MAC Addresses**: Some placeholder MAC addresses (00:00:00:00:00:XX) remain in DHCP static leases and should be updated with actual device MAC addresses
2. **Single Bridge**: All LAN ports are part of the same bridge, simplifying management while maintaining logical organization through comments and DHCP leases
3. **Device Organization**: 
   - WiFi APs on dedicated ports with static IPs
   - Servers have dedicated ethernet ports and organized IP range (.40+)
   - Client devices (desktop, gaming) use mixed WiFi/ethernet with .30+ IPs
   - SmartHome hub (Vivint) connects wirelessly but has static IP reservation
4. **Expandability**: Additional devices can be easily added by updating comments and adding new static leases as needed

## Management Access
- **Management Interface**: ether1 (192.168.88.254/24)
- **SSH/WinBox**: Allowed on management interface
- **Web Access**: Available through management interface or LAN bridge IP (192.168.1.1)
