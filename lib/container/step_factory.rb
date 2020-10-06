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

    class Databases < StepFactory ; end
  end
end
