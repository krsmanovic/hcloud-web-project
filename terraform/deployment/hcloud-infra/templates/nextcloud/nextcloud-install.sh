#!/bin/bash

# setup data volume
mkfs.ext4 -F ${data_volume_dev}
mkdir /data
mount -o discard,defaults ${data_volume_dev} /data
echo '${data_volume_dev} /data ext4 discard,nofail,defaults 0 0' | sudo tee -a /etc/fstab

# download nextcloud
wget https://download.nextcloud.com/server/releases/latest.zip -P /var/www
cd /var/www
unzip -q latest.zip
rm latest.zip

# install nextcloud
mkdir -p /data/nextcloud/
chown www-data:www-data /var/www/nextcloud/ /data/nextcloud/ -R
cd /var/www/nextcloud
sudo -u www-data php occ maintenance:install --database 'pgsql' --database-name 'nextcloud' --database-user 'nextcloud' --database-pass '${nc_db_pass}' --admin-user '${nc_admin_username}' --admin-pass '${nc_admin_password}' --admin-email ${nc_admin_email} --data-dir /data/nextcloud
sudo -u www-data php occ config:system:set trusted_domains 1 --value=${domain}
