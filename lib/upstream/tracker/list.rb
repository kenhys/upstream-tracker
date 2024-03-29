require 'thor'
require 'open-uri'
require 'nokogiri'
require 'pp'
require 'upstream/tracker'

module Upstream
  module Tracker
    class List < Thor

      include Upstream::Tracker::Helper

      desc "library", "List libraries"
      option :remote, :required => false
      def library
        if options.has_key?("remote")
          html = fetch_index_html(options)
          doc = Nokogiri::HTML.parse(html[:data], nil, html[:charset])
          doc.xpath("//table[@id='Components']").each do |table|
            components = {}
            table.xpath("tr").each do |tr|
              unless tr.attribute("id").value =~ /^(top|bottom)Header/
                component = extract_component(tr)
                print_component(component)
                id = component[:id]
                components[id] = component
              end
            end
            if options.has_key?("remote")
              save_components(components)
            end
          end
        else
          path = get_component_path
          YAML.load_file(path).each do |key, component|
            print_component(component)
          end
        end
      end

      desc "version LIBRARY", "List version of library"
      def version(library = "")
        path = get_component_path
        YAML.load_file(path).each do |key, component|
          next unless key == library.downcase
          path = File.join(get_config_dir,
                           "compat_reports",
                           key,
                           "#{key}.yml")
          printf("Versions: %s\n",
                 YAML.load_file(path).keys.join(', '))
        end
      end

      private

      def extract_component(tr)
        label = tr.attribute("id").value
        id = nil
        html_file = nil
        summary = nil
        versions = nil
        tr.xpath("td").each do |td|
          case td.attribute("class").value
          when "left"
            html_file = td.children.attribute("href").value
            id = html_file.sub(/versions\/(.+)\.html/, '\1')
          when "summary"
            summary = td.children.text.sub(/ \(site, doc\)/, '')
          when "results"
            versions = td.children.text.to_i
          end
        end
        component = {
          :id => id,
          :label => label,
          :html => html_file,
          :summary => summary,
          :versions => versions
        }
      end

      def print_component(component)
        printf("%30s: %s (%s versions)\n",
               component[:label] + "(" + component[:id] + ")",
               component[:summary],
               component[:versions])
      end
    end
  end
end
