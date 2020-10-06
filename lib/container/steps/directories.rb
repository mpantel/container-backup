module Container
  module Backup
    class Directories < Step
      #  - "backup={directories: [/var/www/html/libraries, /var/www/html/modules, /var/www/html/profiles, /var/www/html/themes, /var/www/html/sites]}"
      def stop
        sh "#{DockerCompose.docker_compose} stop #{container}"
      end

      def start
        sh "#{DockerCompose.docker_compose} up -d #{container}"
      end

      def tar_volume(option)
        raise "Invalid tar option #{option}" unless option =~ /\A[cx]\z/
        sh "docker run --rm --volumes-from #{container} -v #{backup_path}:/backup ubuntu bash -c \"cd #{volume} && tar #{option}vf /backup/#{volume}.tar #{option == 'c' ? ' .' : ''}\""
      end
      def backup
        stop
        mkdir_p(backup_path)
        backup_volume
        start
      end

      def restore
        stop
        remove_volume
        recover_volume
        start
      end
      def backup_volume
        tar_volume('c')
      end

      def recover_volume
        tar_volume('x')
      end

      def remove_volume
        puts "Remove all files from #{volume} (y/n)?"
        if gets.chomp  == 'y'
          sh "docker run --rm --volumes-from #{container} ubuntu bash -c \"rm -rf #{volume}\""
        else
          exit
        end
      end
    end
  end
end