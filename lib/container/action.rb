require "container/docker_compose"
require "container/parameter"
require "container/step_factory"
require "container/steps/directories"
require "container/steps/volumes"
require "container/steps/databases"
require 'byebug' rescue nil

module Container
  module Backup
    class Action
      def self.perform
        parameters = Parameter.parse(ARGV)
        pp parameters if parameters[:review]
        DockerCompose.file = parameters[:filename]
        backups = DockerCompose.instance.with_label
        pp backups if  parameters[:review]
        parameters[:containers] = backups.keys if parameters[:containers].size == 0
        containers =  parameters[:containers] - ( parameters[:containers]- backups.keys.map(&:keys).flatten)
        pp containers if parameters[:review]
        pp backups.keys if parameters[:review]
        backups.keys.select{|k| containers.include?(k.keys.first)}.each do |container_info|
          backup = :details if parameters[:details]
          backup ||= parameters[:backup] && !parameters[:restore]
          Action.new(container_info,parameters[:directory],backup,backups[container_info]).perform
        end
      rescue Errno::ENOENT => e
        puts "File not found: #{e.message}"
      end

      def perform
        @steps.each(&:perform)
      end
      def initialize(container_info,directory,backup,actions)
        @container_info = container_info
        @directory = directory
        @backup = backup
        @steps = StepFactory.generate(@container_info, @directory, @backup,actions)
      end
    end
  end
end