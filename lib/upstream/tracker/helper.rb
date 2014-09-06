require 'upstream/tracker'

module Upstream
  module Tracker
    module Helper
      def get_config_dir
        directory = File.join(ENV['HOME'], '.upstream-tracker')
        unless Dir.exist?(directory)
          Dir.mkdir(directory)
        end
        directory
      end

      def get_config_path
        File.join(get_config_dir, CONFIG_FILE)
      end

      def load_config
        YAML.load_file(get_config_path)
      end

      def save_config(config)
        File.open(get_config_path, "w+") do |file|
          file.puts(YAML.dump(config))
        end
      end

      def save_components(components)
        path = File.join(get_config_dir, COMPONENT_FILE)
        File.open(path, "w+") do |file|
          file.puts(YAML.dump(components))
        end
      end
    end
  end
end
