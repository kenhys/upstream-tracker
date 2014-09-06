require 'thor'
require 'fileutils'
require 'upstream/tracker'

module Upstream
  module Tracker
    class Init < Thor

      include Upstream::Tracker::Helper

      desc "config", "Initialize configuration"
      def config
        get_config_dir
        dest = get_config_path
        unless File.exist?(dest)
          src = File.dirname(__FILE__) + "/../../../examples/#{CONFIG_FILE}"
          FileUtils.cp(src, dest)
        end
      end

    end
  end
end
