require 'thor'
require 'yaml'
require 'upstream/tracker'

module Upstream
  module Tracker

    CONFIG_FILE = 'upstream-tracker.yml'
    COMPONENT_FILE = 'components.yml'
    UPSTREAM_TRACKER_URL = "http://upstream-tracker.org/"

    class Config < Thor

      include Upstream::Tracker::Helper

      desc "show", "Show current configuration"
      def show
        config = load_config
        puts "upstream-tracker configuration:"
        config.keys.each do |key|
          printf " %10s: %s\n", key, config[key]
        end
      end

    end
  end
end
