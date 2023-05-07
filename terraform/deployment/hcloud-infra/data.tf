# bastion
data "template_file" "bastion_user_data" {
  template = file("${path.module}/templates/bastion/cloud-init.yaml")
  vars = {
    server_name     = var.server_name.bastion
    ops_private_key = base64encode(module.ssh_key.private_key)
    ops_public_key  = module.ssh_key.public_key
    ops_user_name   = data.aws_ssm_parameter.ssh_user_name.value
  }
}

# nextcloud
data "template_file" "nextcloud_user_data" {
  template = file("${path.module}/templates/nextcloud/cloud-init.yaml")
  vars = {
    cert_email        = data.aws_ssm_parameter.nextcloud_cert_email.value
    domain            = data.aws_ssm_parameter.nextcloud_domain.value
    nextcloud_install = base64encode(data.template_file.nextcloud_install.rendered)
    nginx_config      = base64encode(data.template_file.nextcloud_nginx_config.rendered)
    server_name       = var.server_name.nextcloud
    ops_public_key    = module.ssh_key.public_key
    ops_user_name     = data.aws_ssm_parameter.ssh_user_name.value
    posgresql_setup   = base64encode(data.template_file.nextcloud_postgresql.rendered)
  }
}

data "template_file" "nextcloud_install" {
  template = file("${path.module}/templates/nextcloud/nextcloud-install.sh")
  vars = {
    data_volume_dev    = module.nextcloud_data_volume.volume_device
    format_data_volume = var.format_nextcloud_data_volume
    domain             = data.aws_ssm_parameter.nextcloud_domain.value
    nc_admin_username  = data.aws_ssm_parameter.nextcloud_admin_username.value
    nc_admin_password  = data.aws_ssm_parameter.nextcloud_admin_password.value
    nc_admin_email     = data.aws_ssm_parameter.nextcloud_cert_email.value
    nc_db_pass         = random_password.nextcloud_db_user.result
    nc_user_name       = data.aws_ssm_parameter.nextcloud_user_name.value
    nc_user_password   = data.aws_ssm_parameter.nextcloud_user_password.value
    nc_mail_user       = data.aws_ssm_parameter.nextcloud_mail_user.value
    nc_mail_password   = data.aws_ssm_parameter.nextcloud_mail_password.value
    nc_mail_domain     = data.aws_ssm_parameter.nextcloud_mail_domain.value
    nc_mail_host       = data.aws_ssm_parameter.nextcloud_mail_host.value
  }
}

data "template_file" "nextcloud_nginx_config" {
  template = file("${path.module}/templates/nextcloud/nginx.conf")
  vars = {
    domain = data.aws_ssm_parameter.nextcloud_domain.value
  }
}

data "template_file" "nextcloud_postgresql" {
  template = file("${path.module}/templates/nextcloud/postresql.sql")
  vars = {
    nextcloud_db_password = random_password.nextcloud_db_user.result
  }
}

data "aws_ssm_parameter" "nextcloud_domain" {
  name = "/hcloud/web-project/server/nextcloud/domain"
}

data "aws_ssm_parameter" "nextcloud_domain_main" {
  name = "/hcloud/web-project/server/nextcloud/domain/main"
}

data "aws_ssm_parameter" "nextcloud_domain_host" {
  name = "/hcloud/web-project/server/nextcloud/domain/host"
}

data "aws_ssm_parameter" "nextcloud_cert_email" {
  name            = "/hcloud/web-project/server/nextcloud/cert/email"
  with_decryption = true
}

data "aws_ssm_parameter" "nextcloud_admin_username" {
  name            = "/hcloud/web-project/server/nextcloud/user/admin/name"
  with_decryption = true
}

data "aws_ssm_parameter" "nextcloud_admin_password" {
  name            = "/hcloud/web-project/server/nextcloud/user/admin/password"
  with_decryption = true
}

data "aws_ssm_parameter" "nextcloud_user_name" {
  name            = "/hcloud/web-project/server/nextcloud/user/name"
  with_decryption = true
}

data "aws_ssm_parameter" "nextcloud_user_password" {
  name            = "/hcloud/web-project/server/nextcloud/user/password"
  with_decryption = true
}

data "aws_ssm_parameter" "nextcloud_mail_user" {
  name            = "/hcloud/hcloud-web-project/smtp/user"
  with_decryption = true
}

data "aws_ssm_parameter" "nextcloud_mail_password" {
  name            = "/hcloud/hcloud-web-project/smtp/password"
  with_decryption = true
}

data "aws_ssm_parameter" "nextcloud_mail_host" {
  name            = "/hcloud/hcloud-web-project/smtp/host"
  with_decryption = true
}

data "aws_ssm_parameter" "nextcloud_mail_domain" {
  name            = "/hcloud/hcloud-web-project/smtp/domain"
  with_decryption = true
}

data "aws_ssm_parameter" "ssh_user_name" {
  name            = "/hcloud/hcloud-web-project/server/ssh/user"
  with_decryption = true
}

resource "random_password" "nextcloud_db_user" {
  length      = 20
  min_lower   = 2
  min_numeric = 2
  min_special = 2
  min_upper   = 2
  # create cloud-init friendly password
  special          = true
  override_special = "$(%&!=+@"
}
