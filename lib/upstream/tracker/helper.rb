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
        path = File.join(get_config_dir, CONFIG_FILE)
        unless File.exist?(path)
          File.open(path, "w+") do |file|
            file.puts(YAML.dump({}))
          end
        end
        path
      end

      def load_config
        YAML.load_file(get_config_path)
      end

      def save_config(config)
        File.open(get_config_path, "w+") do |file|
          file.puts(YAML.dump(config))
        end
      end

    end
  end
end
