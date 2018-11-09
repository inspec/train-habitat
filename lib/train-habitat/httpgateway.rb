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
        selected = services.select(&by_origin(origin))
                           .select(&by_name(name))

        validate!(selected, origin, name)

        selected.first
      end

      private

      def by_origin(origin)
        lambda do |s|
          s.dig('pkg', 'origin') == origin
        end
      end

      def by_name(name)
        lambda do |s|
          s.dig('pkg', 'name') == name
        end
      end

      def validate!(service, origin, name)
        raise NoServicesFoundError.new(origin, name) if service.empty?
        raise MultipleServicesFoundError.new(origin, name) if service.size > 1
      end
    end
  end
end
