require 'rake'
require 'rake/file_utils_ext'

module Container
  module Backup
    class StepFactory
      def self.get_class(type)
        klass = Object.const_get(['Container', 'Backup', type.capitalize].join('::'))
        if klass.ancestors.include? Container::Backup::Step
          klass
        else
          raise 'Unknown step for #{klass}'
        end
      end

      def self.generate(container, directory, backup, actions)
        actions.map do |a|
          a.map do |type, steps|
            steps.map do |param|
              if Object.const_get(['Container', 'Backup', type.capitalize].join('::')).superclass == Container::Backup::StepFactory
                (param.is_a?(String) ? {param => {}} : param).map do |type, param|
                  StepFactory.build(container, directory, backup, type, param)
                end
              else
                StepFactory.build(container, directory, backup, type, param)
              end
            end
          end
        end.flatten
      end

      def self.build(container, directory, backup, type, params)
        StepFactory.get_class(type).new(container, directory, backup, params)
      end

    end

    class Databases < StepFactory

    end

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
