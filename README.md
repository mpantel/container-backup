# Container::Backup

*Caution:* **Early Prerelease**

## Description

Uses docker-compose backup labels for each container to backup/restore specified assets
```
Supported assets include:
    - databases
        - mssql 
        - mysql
        - mongodb
        - influxdb
        - chronograf   
    - volumes
    - directories
```
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'container-backup'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install container-backup

## Usage

Usage: container-backup [options] container_names

Back up or restore container assets base on docker-compose label configuration

available backup types include:

  * volumes
  * databases
  * mapped directories
  
```
    -f, --file=DOCKERFILE            Docker file with backup/restore configuration
    -b, --backup                     Backup
    -d, --directory=BACKUP_DIRECTORY Backup
    -r, --restore                    Restore
        --review                     Review backup/restore actions
        --details                    Review backup/restore actions with commands to be executed
    -h, --help                       Prints this help
```
## Assumptions

Every container has a mapped directory where backups are externally stored:

```YML
    volumes:
      - "mysql_data:/var/lib/mysql"
      - "./backups:/root/backups"
      - "./backup:/backup"
```

Include the backup label in your docker compose files as follows:

```YML    
     labels:
          - "backup={volumes: [mongo_data],databases: [mongo: {user: ${MONGO_INITDB_ROOT_USERNAME}, password: ${MONGO_INITDB_ROOT_PASSWORD}}]}"
          - "backup.1={volumes: [influxdb_data],databases: [influxdb: {user: ${INFLUXDB_ADMIN_USER},password: ${INFLUXDB_ADMIN_PASSWORD}}]}"
          - "backup.chronograf={volumes: [chronograf_data],databases: [chronograf]}"
          - "backup.2={directories: [/var/www/html/libraries, /var/www/html/modules, /var/www/html/profiles, /var/www/html/themes, /var/www/html/sites]}"
          - "backup.drupal={volumes: [drupal_mysql_data],databases: [mysql: {db: ${MYSQL_DATABASE},password: ${MYSQL_ROOT_PASSWORD},user: root}]}"
```    

In the above example env variables are getting replaced during backup execution, as below:


{volumes: [mongo_data],databases: [mongo: {user: ${MONGO_INITDB_ROOT_USERNAME}, password: ${MONGO_INITDB_ROOT_PASSWORD}}]}

becomes

{volumes: [mongo_data],databases: [mongo: {user: 'username', password: 'password']}}]}

replacing contents of with actual value environmental value

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mpantel/container-backup. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/container-backup/blob/master/CODE_OF_CONDUCT.md).

## similar projects

https://github.com/backup/backup



## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Container::Backup project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/container-backup/blob/master/CODE_OF_CONDUCT.md).


