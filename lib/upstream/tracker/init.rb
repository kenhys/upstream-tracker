require 'thor'
require 'upstream/tracker'

module Upstream
  module Tracker
    class Init < Thor

      include Upstream::Tracker::Helper

      desc "config", "Initialize configuration"
      def config
      end

    end
  end
end
