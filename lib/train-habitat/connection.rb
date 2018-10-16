require 'net/http'
require 'json'
require 'train-habitat/platform'

module TrainPlugins
  module Habitat
    class Connection < Train::Plugins::Transport::BaseConnection
      include TrainPlugins::Habitat::Platform

      def initialize(options)
        msg = 'Habitat host serving HTTP Gateway is required'
        raise Train::TransportError, msg if options.nil? || options[:host].nil?

        super(options)
      end

      def uri
        "habitat://#{@options[:host]}"
      end

      # Example usage in an InSpec Resource Pack: inspec.backend.habitat_client.services
      def habitat_client
        klass = HTTPGateway

        return klass.new(@options[:host]) unless cache_enabled?(:api_call)
        @cache[:api_call][klass.to_s.to_sym] ||= klass.new(@options[:host])
      end
    end

    class HTTPGateway
      attr_reader :uri

      def initialize(host)
        @uri = URI("http://#{host}:9631/services")
      end

      def services
        res = Net::HTTP.get_response(uri)

        JSON.parse(res.body)
      end
    end
  end
end
