require "container/backup/version"
require "container/docker_compose"
require "container/parameter"
require 'fileutils'
require 'byebug' rescue nil



module Container
  module Backup
    class Error < StandardError; end

    pp    Parameter.parse(ARGV)

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