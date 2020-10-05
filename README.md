# Container::Backup

## Description

Uses docker compose backup label for each container to backup/restore specied assets

Supported assets will include
    - databases
        - mssql 
        - mysql
        - mongodb
        - influxdb
        - chronograf   
    - volumes
    - directories

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

Include the backup label in your docker compose files as follows:

```YML    
     labels:
          - "backup={volumes: [mongo_data],databases: [mongo: {user: ${MONGO_INITDB_ROOT_USERNAME}, password: ${MONGO_INITDB_ROOT_PASSWORD}}]}"
          - "backup={volumes: [influxdb_data],databases: [influxdb: {user: ${INFLUXDB_ADMIN_USER},password: ${INFLUXDB_ADMIN_PASSWORD}}]}"
          - "backup={volumes: [chronograf_data],databases: [chronograf]}"
          - "backup={directories: [/var/www/html/libraries, /var/www/html/modules, /var/www/html/profiles, /var/www/html/themes, /var/www/html/sites]}"
          - "backup={volumes: [drupal_mysql_data],databases: [mysql: {db: ${MYSQL_DATABASE},password: ${MYSQL_ROOT_PASSWORD},user: root}]}"
```    

In the above example env variables are getting replaced during backup execution


{volumes: [mongo_data],databases: [mongo: {user: ${MONGO_INITDB_ROOT_USERNAME}, password: ${MONGO_INITDB_ROOT_PASSWORD}}]}

becomes

{volumes: [mongo_data],databases: [mongo: {user: "#{ENV['MONGO_INITDB_ROOT_USERNAME']}", password: "#{ENV['MONGO_INITDB_ROOT_PASSWORD']}}]}

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/container-backup. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/container-backup/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Container::Backup project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/container-backup/blob/master/CODE_OF_CONDUCT.md).


