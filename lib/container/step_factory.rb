module Container
  module Backup
    class StepFactory
      def self.get_class(type)
        klass = Object.const_get(['Container', 'Backup', type.capitalize].join('::'))
        if klass.superclass == Container::Backup::Step
          klass
        else
          raise 'Unknown step for #{klass}'
        end
      end

      def self.generate(container, directory, backup, actions)
        actions.flat_map do |type, steps|
          steps.map do |param|
            if Object.const_get(['Container', 'Backup', type.capitalize].join('::')).superclass == Container::Backup::StepFactory
              (param.is_a?(String) ? {param => {}} : param).map do |type, param|
                StepFactory.build(container, directory, backup, type, param)
              end
            else
              StepFactory.build(container, directory, backup, type, param)
            end
          end.flatten
        end
      end

      def self.build(container, directory, backup, type, step)
        StepFactory.get_class(type).new(container, directory, backup, step)
      end

    end

    class Databases < StepFactory

    end

    class Step
      def initialize(container, directory, backup, step)
        @container = container
        @directory = directory
        @backup = backup
        @step = step
      end

      def perform
        @backup ? backup : restore
      end

      def backup
        puts "Backup: #{self.class} container: #{@container} step: #{@step}"
      end

      def restore
        puts "Restore: #{self.class} container: #{@container} step: #{@step}"
      end
    end

    class Mysql < Step

    end

    class Mssql < Step

    end

    class Mongo < Step

    end

    class Chronograf < Step

    end

    class Influxdb < Step

    end

    class Directories < Step

    end

    class Volumes < Step

    end

  end
end
