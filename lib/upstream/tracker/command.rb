require 'thor'
require 'upstream/tracker'

module Upstream
  module Tracker
    class Command < Thor

      desc "list [SUBCOMMAND]", "List [TARGET]"
      subcommand "list", List
    end
  end
end
