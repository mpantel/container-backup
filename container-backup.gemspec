require_relative 'lib/container/backup/version'

Gem::Specification.new do |spec|
  spec.name          = "container-backup"
  spec.version       = Container::Backup::VERSION
  spec.authors       = ["Michail Pantelelis"]
  spec.email         = ["mpantel@aegean.gr"]

  spec.summary       = %q{Uses docker compose backup lable for each container to drive backup and restore}
  spec.description   = %q{labels:
      - "backup={volumes: [mongo_data],databases: [mongo: {user: ${MONGO_INITDB_ROOT_USERNAME}, password: ${MONGO_INITDB_ROOT_PASSWORD}}]}"
      - "backup={volumes: [influxdb_data],databases: [influxdb: {user: ${INFLUXDB_ADMIN_USER},password: ${INFLUXDB_ADMIN_PASSWORD}}]}"
      - "backup={volumes: [chronograf_data],databases: [chronograf]}"
      - "backup={directories: [/var/www/html/libraries, /var/www/html/modules, /var/www/html/profiles, /var/www/html/themes, /var/www/html/sites]}"
      - "backup={volumes: [drupal_mysql_data],databases: [mysql: {db: ${MYSQL_DATABASE},password: ${MYSQL_ROOT_PASSWORD},user: root}]}"
}
  spec.homepage      = "https://github.com/mpantel/container-backup"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mpantel/container-backup"
  spec.metadata["changelog_uri"] = "https://github.com/mpantel/container-backup"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rake', '~> 12.0'

  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'byebug'

end
