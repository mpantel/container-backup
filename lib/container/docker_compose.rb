require 'yaml'
# http://www.albertoalmagro.com/en/ruby-methods-defined-in-rake-tasks/
module Container
  class DockerCompose
    def load_config(file)
      YAML.load_file(file)
    end

    def initialize
      @file = 'samples/docker-compose.yml'
      @service_tag = 'services'
      @config = load_config(@file)
    end

    def services
      @services ||= @config[@service_tag.to_s]
    end

    def parse_env(string = nil)
      #addapted from https://www.shakacode.com/blog/masking-pii-with-ruby-gsub-with-regular-expression-named-match-groups/
      # and https://cmsdk.com/javascript/regex-to-match-string-with-contains-closed-brackets.html
      # replace { ${XXX} ${YYYY}} => { ENV['XXX'] ENV['YYYY'] }
      string.gsub(/(?<match>\$\{(?<variable>\g<match>|[^${}]++)*\})/) { |match| ENV[$~[:variable]] } if string
    end

    def with_label(label_key: 'backup')
      services.inject({}) do |h, (k, v)|
        value = (v.dig('labels').
            map { |l| l.split('=') }.
            find { |l| l.first == label_key.to_s })
        value ? h.merge({k => YAML.load(parse_env(value.last))}) : h
      end
    end
  end
end