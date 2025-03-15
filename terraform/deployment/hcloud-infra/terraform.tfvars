application_name = "hcloud-web-project"
hcloud_location  = "nbg1" # Nuremberg
ssh_key_name     = "w10"

base_images = {
  bastion   = "67794396" # "ubuntu-22.04", a bug in hcloud provider returns more than one result so we are using id instead of name
  nextcloud = "67794396" # "ubuntu-22.04"
  web       = "ubuntu-22.04"
}

server_type = {
  bastion   = "cx11"  # 1 vCPU, 2 GB RAM, 20 GB ssd, 20 TB of traffic
  nextcloud = "cx21"  # 2 vCPU, 4 GB RAM, 40 GB ssd, 20 TB of traffic
  web       = "cpx11" # 2 vCPU, 2 GB RAM, 40 GB ssd, 20 TB of traffic
}

private_ip_address_nextcloud = "10.0.0.3"
private_ip_address_web = "10.0.0.4"
