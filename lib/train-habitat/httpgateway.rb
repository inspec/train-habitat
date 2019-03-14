require 'uri'
require 'net/http'

module TrainPlugins
  module Habitat
    class HTTPGateway
      attr_reader :base_uri

      def initialize(opts)
        @base_uri = URI(opts[:url])
        # check for provided port and default if not provided
        if base_uri.port == 80 && opts[:url] !~ %r{\w+:\d+(\/|$)}
          base_uri.port = 9631
        end
      end
    end
  end
end
