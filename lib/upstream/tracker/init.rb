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

      desc "library [LIBRARY]", "Initialize library"
      option :list, :required => false
      def library(arg = "")
        if options.has_key?("list")
          #p options
          exit
        end
        exit unless arg
        arg.split(/,/).each do |library|
          components = load_component
          if components.keys.include?(library)
            fetch_versions_html(components[library])
          end
        end
      end

      private

      def fetch_versions_html(component)
        p component
        url = UPSTREAM_TRACKER_URL + component[:html]
        html = fetch_html(url)
        path = File.join(get_config_dir, component[:html])
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, "w+") do |file|
          file.puts(html[:data])
        end
        html
      end

    end
  end
end
