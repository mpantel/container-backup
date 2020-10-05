require 'optparse'

class Parameter
  def self.parse(options)
    args = {}

    opt_parser = OptionParser.new do |opts|

      opts.banner = <<BANNER
Usage: #{File.basename($0)} [options] container_names"

Back up or restore container assets base on docker-compose label configuration
Handles:
  -- volumes
  -- databases
  -- mapped directories

BANNER

      args[:filename] ='docker-compose.yml'
      opts.on("-fDOCKERFILE", "--filename=DOCKERFILE", "Docker file with backup/restore configuration") do |n|
        args[:filename] = n
        end
      opts.on("-b", "--backup", "Backup") do |n|
        args[:backup] = n
        end
      opts.on("-r", "--restore", "Restore") do |n|
        args[:restore] = n
        end
      opts.on( "--review", "Review backup/restore actions") do |n|
        args[:review] = n
        end
      opts.on( "--details", "Review backup/restore actions with commands to be executed") do |n|
        args[:details] = n
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)
    return args.merge({containers: ARGV})
  rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e

    puts ["\nError:\n------\n", e.message, "\n------\n"]
    opt_parser.parse!(['-h'])

  end
end