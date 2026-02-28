application_name = "hcloud-web-project"
hcloud_location  = "nbg1" # Nuremberg
ssh_key_name     = "w10"

base_images = {
  bastion   = "ubuntu-24.04"
  nextcloud = "ubuntu-24.04"
  web       = "ubuntu-24.04"
}

server_type = {
  bastion   = "cx23"  # 2 vCPU, 4 GB RAM, 40 GB ssd, 20 TB of traffic
  nextcloud = "cx23"  # 2 vCPU, 4 GB RAM, 40 GB ssd, 20 TB of traffic
  web       = "cx23"  # 2 vCPU, 4 GB RAM, 40 GB ssd, 20 TB of traffic
}

private_ip_address_nextcloud = "10.0.0.3"
private_ip_address_web = "10.0.0.4"
