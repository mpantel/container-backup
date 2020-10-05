module Container
  module Backup
    class Volumes < Directories
      def stop
        sh "docker-compose down #{container}"
      end

      def start
        sh "docker-compose up -d #{container}"
      end

      def remove_container
        puts "Remove container #{container} (y/n)?"
        if gets.chomp == 'y'
          sh "docker rm -f #{container}"
        else
          exit
        end
      end

      def volume
        @params
      end

      def remove_volume
        puts "Remove volume #{volume} (y/n)?"
        if gets.chomp == 'y'
          sh "docker volume rm #{volume}"
        else
          exit
        end

      end

      def create_volume
        sh "docker volume create #{volume}"
      end

      def tar_volume(option)
        raise "Invalid tar option #{option}" unless option =~ /\A[cx]\z/
        sh "docker run --rm -v #{volume}:/temp -v #{backup_path}:/backup ubuntu bash -c \"cd /temp && tar #{option}vf /backup/#{volume}.tar #{option == 'c' ? ' .' : ''}\""
      end

      def backup_volume
        tar_volume('c')
      end

      def recover_volume
        tar_volume('x')
      end

      # https://blog.ssdnodes.com/blog/docker-backup-volumes/
      def backup
        stop
        mkdir_p(backup_path)
        backup_volume
        start
      end

      def restore
        stop
        remove_container
        remove_volume
        recover_volume
        start
      end
    end
  end
end