require "upstream/tracker/version"
require "upstream/tracker/list"
require "upstream/tracker/search"
require "upstream/tracker/use"

module Upstream
  module Tracker
    class Command < Thor

      desc "list [SUBCOMMAND]", "List [TARGET]"
      subcommand "list", List

      desc "search SYMBOL", "Search symbol from http://upstream-tracker.org/."
      subcommand "search", Search

      desc "use LIBRARY", "Specify libraries which you want to use."
      subcommand "use", Use

    end
  end
end
