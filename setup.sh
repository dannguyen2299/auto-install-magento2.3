#!/usr/bin/env bash

# Declare environment variables
source .env
source ./script_import/get_env_script.sh
source ./script_import/env_host.sh
source ./script_import/install_docker.sh

# Run docker
docker compose down
docker compose up -d mysql
docker compose up -d --build

# Set up for composer install
docker compose exec -T php cp auth.json.sample auth.json
docker compose exec -T php sed -i "s/<public-key>/$PUBLIC_KEY/g" ./auth.json
docker compose exec -T php sed -i "s/<private-key>/$PRIVATE_KEY/g" ./auth.json

# Updating packages
#docker compose exec -T php composer update

# Set permission in magento
docker compose exec -T php find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
docker compose exec -T php find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
docker compose exec -T php chmod u+x bin/magento
docker compose exec -T php bash -c "chmod -R 755 ./app/ ./bin/ ./dev/ ./lib/ ./setup/ ./update/"
docker compose exec -T php bash -c "chmod -R 775 ./vendor/"
docker compose exec -T php bash -c "chmod -R 777 ./generated/ ./pub/ ./var"

# Setup site magento
docker compose exec -T php ./bin/magento setup:install --base-url=http://"$HOST_NAME" --db-host="$DB_HOST" --db-name="$MYSQL_DATABASE"  --db-user="$MYSQL_USER" --db-password="$MYSQL_PASSWORD" --admin-firstname="$ADMIN_FIRSTNAME" --admin-lastname="$ADMIN_LASTNAME" --admin-email="$ADMIN_MAIL" --admin-user="$ADMIN_USER" --admin-password="$ADMIN_PASS" --language=ja_JP --currency=JPY --timezone=Asia/Tokyo

# Insert database for varnish
#docker compose exec -T mysql mysql "$MYSQL_DATABASE" -e "insert into core_config_data (scope, scope_id, path, value)
#values ('default','0','system/full_page_cache/caching_application','2'),
#('default','0','system/full_page_cache/varnish/access_list','localhost'),
#('default','0','system/full_page_cache/varnish/backend_host','localhost'),
#('default','0','system/full_page_cache/varnish/backend_port','8080'),
#('default','0','system/full_page_cache/varnish/grace_period','300');"

# Replace "file" to "db" in env.php file
#docker compose exec -T php sed -i 's/files/db/g' ./app/etc/env.php
docker compose exec -T php bash -c "chmod -R 777 ./generated/ ./pub/ ./var"
