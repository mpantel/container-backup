# container-backup

## Uses docker compose backup lable for each container
### supported configurations
!!!
 labels:
      - "backup={volumes: [mongo_data],databases: [mongo: {user: ${MONGO_INITDB_ROOT_USERNAME}, password: ${MONGO_INITDB_ROOT_PASSWORD}}]}"
      - "backup={volumes: [influxdb_data],databases: [influxdb: {user: ${INFLUXDB_ADMIN_USER},password: ${INFLUXDB_ADMIN_PASSWORD}}]}"
      - "backup={volumes: [chronograf_data],databases: [chronograf]}"
      - "backup={directories: [/var/www/html/libraries, /var/www/html/modules, /var/www/html/profiles, /var/www/html/themes, /var/www/html/sites]}"
      - "backup={volumes: [drupal_mysql_data],databases: [mysql: {db: ${MYSQL_DATABASE},password: ${MYSQL_ROOT_PASSWORD},user: root}]}"
!!!
### replaces env variables for use in ruby scripts

{volumes: [mongo_data],databases: [mongo: {user: ${MONGO_INITDB_ROOT_USERNAME}, password: ${MONGO_INITDB_ROOT_PASSWORD}}]}

becomes

{volumes: [mongo_data],databases: [mongo: {user: "#{ENV['MONGO_INITDB_ROOT_USERNAME']}", password: "#{ENV['MONGO_INITDB_ROOT_PASSWORD']}}]}

## Processors

Define rake tasks for processing back up and restore for:

1. container volumes

2. database servers

 - mysql
 - mssql
 - mongo
 - influxdb
 - chronograph
 - etc.

3. mapped folders

