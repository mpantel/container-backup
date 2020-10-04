require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require 'yaml'
require 'fileutils'
require 'byebug' rescue nil
# Uses docker compose backup lable for each container
# supported configurations
# labels:
#      - "backup={volumes: [mongo_data],databases: [mongo: {user: ${MONGO_INITDB_ROOT_USERNAME}, password: ${MONGO_INITDB_ROOT_PASSWORD}}]}"
#      - "backup={volumes: [influxdb_data],databases: [influxdb: {user: ${INFLUXDB_ADMIN_USER},password: ${INFLUXDB_ADMIN_PASSWORD}}]}"
#      - "backup={volumes: [chronograf_data],databases: [chronograf]}"
#      - "backup={directories: [/var/www/html/libraries, /var/www/html/modules, /var/www/html/profiles, /var/www/html/themes, /var/www/html/sites]}"
#      - "backup={volumes: [drupal_mysql_data],databases: [mysql: {db: ${MYSQL_DATABASE},password: ${MYSQL_ROOT_PASSWORD},user: root}]}"

# Returns the configuration from the file as a Hash object
task :initialize do
  # http://www.albertoalmagro.com/en/ruby-methods-defined-in-rake-tasks/
  class DockerCompose
    def load_config(file)
      YAML.load_file(file)
    end

    def initialize
      @file = 'samples/docker-compose.yml'
      @service_tag = 'services'
      @config = load_config(@file)
    end

    def services
      @services ||= @config[@service_tag.to_s]
    end

    def parse_env(string=nil)
      #addapted from https://www.shakacode.com/blog/masking-pii-with-ruby-gsub-with-regular-expression-named-match-groups/
      # and https://cmsdk.com/javascript/regex-to-match-string-with-contains-closed-brackets.html
      # replace { ${XXX} ${YYYY}} => { ENV['XXX'] ENV['YYYY'] }
      string.gsub( /(?<match>\$\{(?<variable>\g<match>|[^${}]++)*\})/) { |match| ENV[$~[:variable]] } if string
    end

    def with_label(label_key: 'backup')
      services.inject({}) do |h,(k,v)|
        value = (v.dig('labels').
            map{|l| l.split('=')}.
            find{|l| l.first == label_key.to_s})
        value ? h.merge({k => YAML.load(parse_env(value.last))}) : h
      end
    end
  end
end
#
#
# get_config('docker-compose.yml').each do |f|
#
#   config = get_config(f)
#
#   namespace config[:name] do
#
#     # Generate tasks
#
#     desc "First task for #{config[:name]}"
#     task config[:first] do
#       # Code goes here
#     end
#
#     desc "Second task for #{config[:name]}"
#     task config[:second] do
#       # Code goes here
#     end
#
#     # more...
#
#   end
#
# end


namespace :docker  do
  desc "Backup Docker Volumes"
  task :backup => :initialize do
    dc = DockerCompose.new
    byebug rescue nil
  end
  desc "Restore Docker Volumes"
  task :volume_restore do

  end
end

namespace :db do
  desc "Backup DBs"
  task :backup do

  end



  desc "Restore DBs"
  task :restore do

  end
end


__END__

#!/usr/bin/env bash
# https://blog.ssdnodes.com/blog/docker-backup-volumes/


$ docker stop ghost-site

Next, we spin up a temporary container with the volume and the backup folder mounted into it.

$ mkdir ~/backup
$ docker run --rm --volumes-from ghost-site -v ~/backup:/backup ubuntu bash -c “cd /var/lib/ghost/content && tar cvf /backup/ghost-site.tar .”


## restore

$ docker rm -f ghost-site
$ docker volume rm my-volume

Now, the steps for recovery would involve:

                                      Creating a new volume
Spinning up a temporary container to recover from the tarball into this volume
Mounting this volume to the new container

$ docker volume create my-volume-2
$ docker run --rm -v my-volume-2:/recover -v ~/backup:/backup ubuntu bash -c “cd /recover && tar xvf /backup/ghost-site.tar”
$ docker run -d -v my-volume-2:/var/lib/ghost/content -p 80:2368 ghost:latest



#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#REGISTRY=psmart.aegean.gr:5000
#
#cd $DIR

CONTAINERS=("psmart-mongo" "psmart-influxdb" "psmart-chronograf"   "psmart-mysql"  "psmart-website")
BACKUP_DIR="~/backup/$(date -d "today" +"%Y-%m-%dT%H%M")"

mkdir -p $BACKUP_DIR

for c in "${CONTAINERS[@]}"
  do

  docker stop $c
  docker run --rm --volumes-from $c -v $BACKUP_DIR:/backup ubuntu bash -c "cd /var/lib/ghost/content && tar cvf /backup/$c.tar ."

  if [ ! -d ./$i ]  # For file "if [-f /home/rama/file]"
  then
      git clone git@gitlab.com:privasi-iot/$i.git
  fi
   echo -e $TEXT_GREEN
   echo "Pulling $i..."
   echo -e $TEXT_RESET

   git -C ./$i pull
   git -C ./$i checkout dev
   # git -C ./$i checkout master

   echo -e $TEXT_GREEN
   echo "Building $i..."
   echo -e $TEXT_RESET

   docker run \
    -v $DIR/login_config.json:/kaniko/.docker/config.json:ro \
    -v $DIR/$i:/workspace \
    gcr.io/kaniko-project/executor:latest \
    --dockerfile "/workspace/Dockerfile" --destination "$REGISTRY/$i:latest" --context dir:///workspace/ \
    --cache=false --skip-tls-verify

   echo -e $TEXT_GREEN
   echo "Building $i... [OK]"
   echo -e $TEXT_RESET
done
=end