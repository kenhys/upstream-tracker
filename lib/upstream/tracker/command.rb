require 'thor'
require 'upstream/tracker'

module Upstream
  module Tracker
    class Command < Thor

      desc "list [SUBCOMMAND]", "List [TARGET]"
      subcommand "list", List

      desc "search SYMBOL", "Search symbol from http://upstream-tracker.org/."
      subcommand "search", Search
    end
  end
end
