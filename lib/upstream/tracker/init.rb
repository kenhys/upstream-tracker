require 'thor'
require 'fileutils'
require 'pp'
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
            html = fetch_versions_html(components[library])
            path = File.join(get_config_dir,
                             components[library][:html])
            p path
            #html = fetch_local_html(path)
            component = extract_compat_reports(html)

            path = File.join(get_config_dir,
                             "compat_reports",
                             library,
                             "#{library}.yml")
            FileUtils.mkdir_p(File.dirname(path))
            File.open(path, "w+") do |file|
              file.puts(YAML.dump(component))
            end
            component.each do |key, version|
              url = UPSTREAM_TRACKER_URL + version[:html]
              path = File.join(get_config_dir,
                               version[:html])
              download_html(url, path)
              printf("Download ABI compat report: %s\n", url)
            end
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

      def extract_compat_reports(html)
        doc = Nokogiri::HTML.parse(html[:data], nil, html[:charset])
        component = {}
        doc.xpath("//table[@class='wikitable']").each do |table|
          table.xpath("tr[@id]").each do |tr|
            compat = {}
            version = nil
            tr.children.each_with_index do |td, index|
              if td.name == "th"
                version = td.text
                compat[:version] = version
              else
                case index
                when 4
                  # Backward Compatibility
                  td.xpath("a").each do |a|
                    compat[:html] = a.attribute("href").value.sub(/^\.\.\//, '')
                  end
                  compat[:backward_compatibility] = td.text
                when 5
                  compat[:added] = td.text.sub(/ new/, '').to_i
                when 6
                  compat[:removed] = td.text.sub(/ removed/, '').to_i
                end
              end
            end
            if compat[:backward_compatibility].end_with?("\%")
              component[version] = compat
            end
          end
        end
        component
      end
    end
  end
end
