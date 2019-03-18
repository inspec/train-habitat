require 'uri'
require 'httpclient'

module TrainPlugins
  module Habitat
    class HTTPGateway
      Response = Struct.new(:code, :body, :raw_response)

      attr_reader :base_uri

      def initialize(opts)
        @base_uri = URI(opts[:url])
        # check for provided port and default if not provided
        if base_uri.port == 80 && opts[:url] !~ %r{\w+:\d+(\/|$)}
          base_uri.port = 9631
        end

        @auth_token = opts[:auth_token]
      end

      def get_path(path)
        uri = base_uri.dup
        uri.path = path

        resp = Response.new
        client = HTTPClient.new
        headers = {}
        unless auth_token.nil?
          headers['Authorization'] = 'Bearer ' + auth_token # Set bearer token, see https://www.habitat.sh/docs/using-habitat/#authentication
        end

        resp.raw_response = client.get(uri, {}, headers)
        resp.code = resp.raw_response.status
        if resp.code == 200
          resp.body = JSON.parse(resp.raw_response.body, symbolize_names: true)
        end
        resp
      end

      # Private accessor
      attr_reader :auth_token
    end
  end
end
