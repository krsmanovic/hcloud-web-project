#!/bin/bash

# setup data volume
if [[ "yes" == "${format_data_volume}" ]]; then
   echo "Formatting ${data_volume_dev}..."
   mkfs.ext4 -F ${data_volume_dev}
fi
mkdir /data
echo "Mounting ${data_volume_dev} to /data folder"
mount -o discard,defaults ${data_volume_dev} /data
echo '${data_volume_dev} /data ext4 discard,nofail,defaults 0 0' | sudo tee -a /etc/fstab

# download nextcloud
echo "Downloading up Nextcloud..."
wget https://download.nextcloud.com/server/releases/latest.zip -P /var/www
cd /var/www
unzip -q latest.zip
rm latest.zip

# install nextcloud
mkdir -p /data/nextcloud/
chown www-data:www-data /var/www/nextcloud/ /data/nextcloud/ -R
if [[ "no" == "${format_data_volume}" ]]; then
   cd /data/nextcloud/
   echo "Backing up old Nextcloud user files..."
   mv ${nc_admin_username} ${nc_admin_username}-backup
   mv ${nc_user_name} ${nc_user_name}-backup
   rm -rf appdata_oc*
fi
echo "Installing Nextcloud..."
cd /var/www/nextcloud
sudo -u www-data php occ maintenance:install --database 'pgsql' --database-name 'nextcloud' --database-user 'nextcloud' --database-pass '${nc_db_pass}' --admin-user '${nc_admin_username}' --admin-pass '${nc_admin_password}' --admin-email ${nc_admin_email} --data-dir /data/nextcloud
sudo -u www-data php occ config:system:set trusted_domains 1 --value=${domain}

# add nextcloud user
sed -rie "s|(www\-data.*)/usr/sbin/nologin$|\1/bin/bash|" /etc/passwd
cd /var/www/nextcloud
sudo -u www-data OC_PASS=${nc_user_password} php occ user:add --password-from-env --group="users" ${nc_user_name}
sed -rie "s|(www\-data.*)/bin/bash$|\1/usr/sbin/nologin|" /etc/passwd
if [[ "no" == "${format_data_volume}" ]]; then
   cd /data/nextcloud/
   echo "Restoring old Nextcloud user files from backup..."
   rsync -av --remove-source-files ${nc_admin_username}-backup/ ${nc_admin_username}
   rsync -av --remove-source-files ${nc_user_name}-backup/ ${nc_user_name}
   rm -rf ${nc_admin_username}-backup ${nc_user_name}-backup
   cd /var/www/nextcloud
   sudo -u www-data php occ files:scan ${nc_admin_username}
   sudo -u www-data php occ files:scan ${nc_user_name}
fi

# set phone region
sed -i "/);/i\  'default_phone_region' => 'RS'," /var/www/nextcloud/config/config.php

# fix cron job
(2>/dev/null sudo -u www-data crontab -l ; echo "*/5  *  *  *  * php -f /var/www/nextcloud/cron.php") | sudo -u www-data crontab -

# configure smtp
sed -i "/);/i\  'mail_smtpmode' => 'smtp',\n  'mail_smtphost' => '${nc_mail_host}',\n  'mail_domain' => '${nc_mail_domain}',\n  'mail_smtpport' => 587,\n  'mail_smtpauth' => true,\n  'mail_smtptimeout' => 30,\n  'mail_smtpname' => '${nc_mail_user}',\n  'mail_smtppassword' => '${nc_mail_password}'," /var/www/nextcloud/config/config.php

# configure redis cache
usermod -a -G redis www-data
sed -i "/);/i\  'filelocking.enabled' => true,\n  'memcache.locking' => '\\\OC\\\Memcache\\\Redis',\n  'memcache.local' =>'\\\OC\\\Memcache\\\Redis',\n  'redis' => array(\n     'host'    => '/var/run/redis/redis-server.sock',\n     'port'    => 0,\n     'timeout' => 0.0,\n     'dbindex' => 0,\n  )," /var/www/nextcloud/config/config.php

# add Strict-Transport-Security headers
sed -i '/    Header always set X-XSS-Protection "1; mode=block"/a\    # Security hardening\n    Header always set Strict-Transport-Security "max-age=15768000; includeSubDomains"' /var/www/nextcloud/.htaccess
sudo -u www-data php occ maintenance:update:htaccess