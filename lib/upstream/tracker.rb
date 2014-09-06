require "upstream/tracker/version"
require "upstream/tracker/helper"
require "upstream/tracker/config"
require "upstream/tracker/init"
require "upstream/tracker/list"
require "upstream/tracker/search"
require "upstream/tracker/update"
require "upstream/tracker/use"

module Upstream
  module Tracker
    class Command < Thor

      desc "config [SUBCOMMAND]", "Config [TARGET]"
      subcommand "config", Config

      desc "init [SUBCOMMAND]", "Initialize configuration"
      subcommand "init", Init

      desc "list [SUBCOMMAND]", "List [TARGET]"
      subcommand "list", List

      desc "update LIBRARY", "Update ABI/API changes information."
      subcommand "update", Update

      desc "search SYMBOL", "Search symbol from http://upstream-tracker.org/."
      subcommand "search", Search

      desc "use LIBRARY", "Specify libraries which you want to use."
      subcommand "use", Use

    end
  end
end
