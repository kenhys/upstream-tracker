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
        html = fetch_index_html(options)
        doc = Nokogiri::HTML.parse(html[:data], nil, html[:charset])
        doc.xpath("//table[@id='Components']").each do |table|
          components = {}
          table.xpath("tr").each do |tr|
            unless tr.attribute("id").value =~ /^(top|bottom)Header/
              label = tr.attribute("id").value
              puts label
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
                  versions = td.children.text
                end
                components[id] = {
                  :id => id,
                  :label => label,
                  :html => html_file,
                  :summary => summary,
                  :versions => versions
                }
              end
            end
          end
        end
      end

      desc "version LIBRARY", "List version of library"
      def version
      end

    private

      def fetch_index_html(options)
        html = {:data => nil, :charset => nil}
        if options.has_key?("remote")
          url = "http://upstream-tracker.org/"
          html[:data] = open(url) do |file|
            html[:charset] = file.charset
            file.read
          end
        else
          path = File.dirname(__FILE__) + "/../../../top.html"
          html[:data] = open(path) do |file|
            file.read
          end
        end
        html
      end
    end
  end
end
