module "ssh_key" {
  source           = "../../modules/tls-key"
  application_name = var.application_name
  store_locally    = true
  generic_tags     = local.mandatory_tags
  generic_labels   = local.labels
}

module "network" {
  source         = "../../modules/hcloud-network"
  generic_labels = local.labels
}

# bastion
module "bastion_server" {
  source              = "../../modules/hcloud-server"
  server_image        = var.base_images.bastion
  server_type         = var.server_type.bastion
  server_name         = var.server_name.bastion
  enable_backups      = true
  network_id          = module.network.network_id
  firewall_ids        = module.bastion_firewall.bastion_id
  ssh_public_key_name = var.ssh_key_name
  user_data           = data.template_file.bastion_user_data.rendered
  generic_labels      = local.labels
}

module "bastion_firewall" {
  source         = "../../modules/hcloud-firewall"
  rule_type      = "bastion"
  generic_labels = local.labels
}

# nextcloud
module "nextcloud_server" {
  source              = "../../modules/hcloud-server"
  server_image        = var.base_images.nextcloud
  server_type         = var.server_type.nextcloud
  server_name         = var.server_name.nextcloud
  enable_backups      = true
  network_id          = module.network.network_id
  server_private_ip   = var.private_ip_address_nextcloud
  firewall_ids        = module.web_firewall.web_id
  ssh_public_key_name = var.ssh_key_name
  user_data           = data.template_file.nextcloud_user_data.rendered
  generic_labels      = local.labels
}

module "nextcloud_data_volume" {
  source           = "../../modules/hcloud-volume"
  volume_size      = 250
  generic_labels   = local.labels
  automount_volume = false
  server_name      = var.server_name.nextcloud
}

resource "hcloud_volume_attachment" "nextcloud_data" {
  volume_id = module.nextcloud_data_volume.id
  server_id = module.nextcloud_server.server_id
  automount = false
}

module "nextcloud_ssh_firewall" {
  source          = "../../modules/hcloud-firewall"
  name_prefix     = "nextcloud-"
  rule_type       = "bastion"
  source_ip_cidrs = [module.network.network_ip_range, "${module.bastion_server.public_ip}/32"]
  generic_labels  = local.labels
}

# web
# module "web_server" {
#   source              = "../../modules/hcloud-server"
#   server_image        = var.base_images.web
#   server_type         = var.server_type.web
#   server_name         = var.server_name.web
#   enable_backups      = true
#   network_id          = module.network.network_id
#   server_private_ip   = var.private_ip_address_web
#   firewall_ids        = module.web_firewall.web_id
#   ssh_public_key_name = var.ssh_key_name
#   user_data           = data.template_file.nextcloud_user_data.rendered
#   generic_labels      = local.labels
# }

module "web_firewall" {
  source         = "../../modules/hcloud-firewall"
  rule_type      = "web"
  generic_labels = local.labels
}
