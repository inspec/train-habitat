# frozen_string_literal: true
require_relative 'illegal_state_error'

require 'net/http'
require 'json'

module TrainPlugins
  module Habitat
    class HTTPGateway
      attr_reader :uri

      def initialize(host)
        @uri = URI("http://#{host}:9631/services")
      end

      def services
        JSON.parse(Net::HTTP.get_response(uri).body)
      end

      def service(origin, name)
        service = services.select do |svc|
          svc.dig('pkg', 'origin') == origin && svc.dig('pkg', 'name') == name
        end

        raise IllegalStateError.new("Expected one service '#{origin}/#{name}', but found none.") if service.empty?
        raise IllegalStateError.new("Expected one service '#{origin}/#{name}', but found multiple.") if service.size > 1

        service.first
      end
    end
  end
end
