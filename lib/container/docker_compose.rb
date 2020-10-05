require 'yaml'
require 'singleton'
# http://www.albertoalmagro.com/en/ruby-methods-defined-in-rake-tasks/
module Container
  class DockerCompose
    include Singleton
      @@file = ""
      def self.file= composer_file
        @@file = composer_file
      end
      def initialize
        raise "Container::DockerCompose.file not initialized" if @@file.size == 0
        @file = @@file
        @config = load_config(@file)
      end

    def load_config(file)
      YAML.load_file(file)
    end

    def self.docker_compose
       "docker-compose -f #{@@file}"
    end
    def services
      @services ||= @config['services']
    end

    def parse_env(string = nil)
      #addapted from https://www.shakacode.com/blog/masking-pii-with-ruby-gsub-with-regular-expression-named-match-groups/
      # and https://cmsdk.com/javascript/regex-to-match-string-with-contains-closed-brackets.html
      # replace { ${XXX} ${YYYY}} => { ENV['XXX'] ENV['YYYY'] }
      string.gsub(/(?<match>\$\{(?<variable>\g<match>|[^${}]++)*\})/) { |match| ENV[$~[:variable]] } if string
    end

    def with_label(label_key: 'backup')
      services.inject({}) do |h, (k, v)|
        image = parse_env(v.dig('image'))
        values = (v.dig('labels')&.
            map { |l| l.split('=') }&.
            select { |l| l.first.split('.').first == label_key.to_s })
        (values&.size || 0) > 0 ? h.merge({{k => image} => values.map{|value| YAML.load(parse_env(value.last))}}) : h
      end
    end
  end
end