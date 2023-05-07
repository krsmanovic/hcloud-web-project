# wait for nextcloud server setup and reboot to complete
resource "time_sleep" "nextcloud_install" {
  depends_on      = [module.nextcloud_server]
  create_duration = "240s"

  triggers = {
    nextcloud_server_id = module.nextcloud_server.server_id
  }
}

# install nextcloud
resource "null_resource" "nextcloud_install" {
  depends_on = [time_sleep.nextcloud_install]

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
      "sudo bash -c 'rm -rf /root/nextcloud-install.sh'",
      "sudo bash -c 'shutdown -r +0'",
    ]
  }

  triggers = {
    nextcloud_server_id    = module.nextcloud_server.server_id
    data_volume_attachment = hcloud_volume_attachment.nextcloud_data.id
  }
}
