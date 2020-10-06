require 'rake'
require 'rake/file_utils_ext'

module Container
  module Backup
    class Step
      include Rake::FileUtilsExt

      def initialize(container_info, directory, backup, params_hash)
        @container_info = container_info
        @directory = directory
        @backup = backup
        @params = params_hash
      end

      def params
        @params
      end

      def container
        @container_info.keys.first
      end

      def image
        @container_info.values.first
      end

      def backup_path
        [@directory, container, self.class.name.split('::').last.downcase].join('/')
      end

      def perform
        @backup ? backup : restore
      end

      def backup
        puts "Backup path: #{backup_path}"
        puts "Backup: #{self.class} container: #{container} params: #{@params}"
      end

      def restore
        puts "Backup path: #{backup_path}"
        puts "Restore: #{self.class} container: #{container} params: #{@params}"
      end

    end
  end
end
