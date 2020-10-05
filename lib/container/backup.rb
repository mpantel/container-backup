require "container/backup/version"
require "container/action"

module Container
  module Backup
    class Error < StandardError; end

    Action.perform

  end
end
