require "container/docker_compose"
require "container/parameter"
require "container/step_factory"
require "container/step/directories"
require "container/step/volumes"
require "container/step/databases"
require 'byebug' rescue nil

module Container
  module Backup
    class Action
      def self.perform
        parameters = Parameter.parse(ARGV)
        backups = DockerCompose.new(parameters[:filename]).with_label
        parameters[:containers] = backups.keys if parameters[:containers].size == 0
        containers =  parameters[:containers] - ( parameters[:containers]- backups.keys)
        containers.each do |container|
          backup = :review if parameters[:review]
          backup = :details if parameters[:details]
          backup ||= parameters[:backup] && !parameters[:restore]
          Action.new(container,parameters[:directory],backup,backups[container]).perform
        end
      rescue Errno::ENOENT => e
        puts "File not found: #{e.message}"
      end

      def perform
        @steps.each(&:perform)
      end
      def initialize(container,directory,backup,actions)
        @container = container
        @directory = directory
        @backup = backup
        @steps = StepFactory.generate(@container, @directory, @backup,actions)
      end
    end
  end
end