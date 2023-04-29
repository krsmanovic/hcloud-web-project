CREATE DATABASE nextcloud TEMPLATE template0 ENCODING 'UNICODE';

CREATE USER nextcloud WITH PASSWORD '${nextcloud_db_password}';

ALTER DATABASE nextcloud OWNER TO nextcloud; 

GRANT ALL PRIVILEGES ON DATABASE nextcloud TO nextcloud;