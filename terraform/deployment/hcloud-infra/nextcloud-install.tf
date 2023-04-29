resource "time_sleep" "first_install_and_restart" {
  create_duration = "240s"

  triggers = {
    nextcloud_server_id = module.nextcloud_server.server_id
  }
}

resource "null_resource" "nextcloud_install" {
  depends_on = [time_sleep.first_install_and_restart]

  provisioner "remote-exec" {
    connection {
      host        = var.nextcloud_private_ip_address
      port        = 22
      user        = data.aws_ssm_parameter.ssh_user_name.value
      type        = "ssh"
      private_key = module.ssh_key.private_key
      timeout     = "30s"

      bastion_host = module.bastion_server.public_ip
    }
    inline = [
      "sudo bash -c '/root/nextcloud-install.sh'",
    ]
  }

  triggers = {
    nextcloud_server_id    = module.nextcloud_server.server_id
    data_volume_attachment = hcloud_volume_attachment.nextcloud_data.id
  }
}

resource "null_resource" "nextcloud_restart" {
  depends_on = [null_resource.nextcloud_install]

  provisioner "remote-exec" {
    connection {
      host        = var.nextcloud_private_ip_address
      port        = 22
      user        = data.aws_ssm_parameter.ssh_user_name.value
      type        = "ssh"
      private_key = module.ssh_key.private_key
      timeout     = "30s"

      bastion_host = module.bastion_server.public_ip
    }
    inline = [
      "sudo bash -c '/root/reboot.sh'",
    ]

    # Provisioner doesn't report the exit status, but here we'll explicitly allow failure
    on_failure = continue
  }

  triggers = {
    nextcloud_installation = null_resource.nextcloud_install.id
  }
}

resource "time_sleep" "second_restart" {
  create_duration = "60s"

  triggers = {
    nextcloud_restart = null_resource.nextcloud_restart.id
  }
}

resource "null_resource" "nextcloud_add_user" {
  depends_on = [time_sleep.second_restart]

  provisioner "remote-exec" {
    connection {
      host        = var.nextcloud_private_ip_address
      port        = 22
      user        = data.aws_ssm_parameter.ssh_user_name.value
      type        = "ssh"
      private_key = module.ssh_key.private_key
      timeout     = "30s"

      bastion_host = module.bastion_server.public_ip
    }
    inline = [
      "sudo bash -c '/root/nextcloud-add-user.sh'",
    ]
  }

  triggers = {
    nextcloud_restart = null_resource.nextcloud_restart.id
  }
}