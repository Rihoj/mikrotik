# MikroTik CRS326-24G-2S+ Terraform Configuration

This repository contains Terraform configuration for managing a MikroTik CRS326-24G-2S+ switch with unified bridge architecture.

## Initial Hardware Setup

### Prerequisites
- MikroTik CRS326-24G-2S+ switch
- Ethernet cable
- Computer with network access
- WinBox or web browser for initial configuration

### Step 1: Factory Reset (Recommended)
1. Power on the switch
2. Hold the **Reset** button for 10-15 seconds while powered on
3. Release the button and wait for the switch to reboot
4. Default configuration will be restored

### Step 2: Initial Connection
1. Connect your computer to **port 2-24** (any LAN port)
2. The switch should assign your computer an IP via DHCP (192.168.88.x)
3. Default gateway should be `192.168.88.1`

### Step 3: Access the Switch
Choose one of the following methods:

#### Option A: WinBox (Recommended)
1. Download WinBox from [MikroTik's website](https://mikrotik.com/download)
2. Run WinBox
3. Click "..." to scan for devices
4. Select your switch from the list
5. Login with:
   - **Username**: `admin`
   - **Password**: (leave empty)

#### Option B: Web Interface
1. Open browser and go to `http://192.168.88.1`
2. Login with:
   - **Username**: `admin`
   - **Password**: (leave empty)

### Step 4: Configure Management Interface
1. Go to **IP → Addresses**
2. Remove the existing address on `bridge` (192.168.88.1/24)
3. Add new address:
   - **Address**: `192.168.88.254/24`
   - **Interface**: `ether1`
   - **Comment**: `Management interface`

### Step 5: Enable API Access
1. Go to **IP → Services**
2. Find the **api** service
3. Enable it if disabled
4. Note the port (default: 8728)
5. For secure API, also enable **api-ssl** (port 8729)

### Step 6: Create Management User (Recommended)
1. Go to **System → Users**
2. Add new user:
   - **Name**: `terraform`
   - **Group**: `full`
   - **Password**: (create a strong password)
3. Consider disabling the default `admin` user for security

### Step 7: Configure Firewall for Management
1. Go to **IP → Firewall → Filter Rules**
2. Add rule to allow management access:
   - **Chain**: `input`
   - **In Interface**: `ether1`
   - **Action**: `accept`
   - **Comment**: `Allow management via ether1`

## Terraform Setup

### Step 1: Install Terraform
Download and install Terraform from [terraform.io](https://terraform.io/downloads)

### Step 2: Clone and Configure
```bash
git clone <your-repo>
cd microtik
```

### Step 3: Create terraform.tfvars
Create a `terraform.tfvars` file with your settings:

```hcl
# Router connection details
routeros_hosturl  = "http://192.168.88.254:8728"  # or https://192.168.88.254:8729 for SSL
routeros_user     = "terraform"                    # or "admin"
routeros_password = "your-secure-password"

# Optional Wi-Fi settings (CAPsMAN)
enable_capsman    = false                      # Set to true to enable CAPsMAN
wifi_ssid         = "YourHomeWiFi"            # WiFi network name
wifi_passphrase   = "your-wifi-password"       # WiFi password
```

### Step 4: Initialize and Apply
```bash
# Initialize Terraform
terraform init

# Plan the changes
terraform plan -out=tfplan

# Apply the configuration
terraform apply tfplan
```

## Network Architecture

### Port Configuration
- **ether1**: Management interface (192.168.88.254/24)
- **ether2**: WAN/Internet connection
- **ether3-5**: WiFi Access Points
- **ether6-8**: Server infrastructure
- **ether9-24**: General purpose LAN ports

### IP Addressing
- **Management**: 192.168.88.254/24 (isolated management network)
- **LAN Network**: 192.168.1.0/24 (main user network)
- **Gateway**: 192.168.1.1
- **WiFi APs**: 192.168.1.10-11
- **Servers**: 192.168.1.40-42
- **DHCP Pool**: 192.168.1.50-200
- **Inter-subnet Routing**: Enabled between management and LAN networks

## Security Notes

### Important Security Considerations
1. **Change default passwords** immediately after setup
2. **Disable unused services** in IP → Services
3. **Configure proper firewall rules** for WAN interface
4. **Use strong passwords** for all user accounts
5. **Enable API-SSL** instead of plain API for production use

### Management Access
- Only accessible via **ether1** (192.168.88.254)
- SSH: Port 22
- WinBox: Port 8291
- API: Port 8728 (HTTP) or 8729 (HTTPS)

## Troubleshooting

### Cannot Connect to Management Interface
1. Verify ethernet cable is connected to **ether1**
2. Check your computer's IP is in 192.168.88.x range
3. Try factory reset and repeat setup

### Terraform Apply Fails
1. Verify API is enabled on the switch
2. Check `terraform.tfvars` credentials are correct
3. Ensure management interface is accessible from your computer
4. Check firewall rules allow API access

### Lost Management Access
1. Connect to any LAN port (ether2-24)
2. Access via bridge IP (192.168.1.1 after Terraform apply)
3. Or perform factory reset and repeat initial setup

## File Structure
```
.
├── main.tf                   # Provider configuration
├── variables.tf             # Variable definitions
├── mgmt.tf                 # Management interface config
├── wan.tf                  # WAN interface and firewall
├── lan.tf                  # LAN bridge and DHCP
├── lan_ether.tf            # Ethernet port definitions
├── capsman.tf              # WiFi CAPsMAN configuration (optional)
├── subnet_routing.tf       # Inter-subnet routing rules
├── terraform.tfvars        # Your local configuration (not in git)
├── NETWORK_DOCUMENTATION.md # Detailed network documentation
└── README.md               # This file
```

## Support
- [MikroTik Documentation](https://help.mikrotik.com/)
- [RouterOS Manual](https://help.mikrotik.com/docs/display/ROS/)
- [Terraform RouterOS Provider](https://registry.terraform.io/providers/terraform-routeros/routeros/)

---
⚠️ **Warning**: Always backup your router configuration before applying Terraform changes!
