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
          table.xpath("tr").each do |tr|
            unless tr.attribute("id").value =~ /^(top|bottom)Header/
              puts tr.attribute("id").value
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
