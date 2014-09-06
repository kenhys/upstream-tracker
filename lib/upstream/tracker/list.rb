require 'thor'
require 'upstream/tracker'

module Upstream
  module Tracker
    class List < Thor

      include Upstream::Tracker::Helper

      desc "library", "List libraries"
      def library
      end

    end
  end
end
