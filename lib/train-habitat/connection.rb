# frozen_string_literal: true

require 'net/http'
require 'json'
require 'train-habitat/httpgateway'
require 'train-habitat/platform'

module TrainPlugins
  module Habitat
    class Connection < Train::Plugins::Transport::BaseConnection
      include TrainPlugins::Habitat::Platform

      def initialize(options = {})
        if options.nil? || options[:host].nil?
          raise Train::TransportError, 'Habitat host serving HTTP Gateway is required'
        end

        super(options)
      end

      def uri
        "habitat://#{@options[:host]}"
      end

      # Example usage in an InSpec Resource Pack: inspec.backend.habitat_client.services
      def habitat_client
        return HTTPGateway.new(@options[:host]) unless cache_enabled?(:api_call)

        @cache.dig(:api_call, :HTTPGateway) || HTTPGateway.new(@options[:host])
      end
    end
  end
end
