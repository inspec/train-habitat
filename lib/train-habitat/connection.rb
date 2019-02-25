# frozen_string_literal: true

require 'net/http'
require 'json'
require 'train-habitat/httpgateway'
require 'train-habitat/platform'
require 'train-habitat/transport'

module TrainPlugins
  module Habitat
    class Connection < Train::Plugins::Transport::BaseConnection
      include TrainPlugins::Habitat::Platform

      attr_reader :cli_transport_name, :cli_connection, :transport_options

      def initialize(options = {})
        @transport_options = options

        unless api_options_provided? || cli_options_provided?
          raise Train::TransportError, "Habitat connection options that begin with either 'cli' or 'api' required"
        end

        super(transport_options)
        enable_cache :api_call
      end

      def uri
        "habitat://#{@options[:host]}"
      end

      def api_options_provided?
        have_transport_options_with_prefix?('api')
      end

      def cli_options_provided?
        TrainPlugins::Habitat::Transport.cli_transport_prefixes.keys.map(&:to_s).any? do |prefix|
          have_transport_options_with_prefix?(prefix)
        end
      end

      # Use this to execuute a `hab` command. Do not include the `hab` executable in the invocation.
      def run_hab_cli(command, exec_options = {})
        raise CliNotAvailableError(cli_tranport_names) unless cli_options_provided?
        initialize_cli_connection!
        # TODO - leverage exec_options to add things like JSON parsing, ENV setting, etc.
        cli_connection.run_command(hab_path + ' ' + command)
      end

      def habitat_api_client
        cached_client(:api_call, :HTTPGateway) do
          # TODO: add authtoken
          HTTPGateway.new(@options[:api_host])
        end
      end

      private

      def cli_transport_names
        TrainPlugins::Habitat::Transport.cli_transport_prefixes.values
      end

      def have_transport_options_with_prefix?(prefix)
        transport_options.keys.map(&:to_s).any? { |option_name| option_name.start_with? prefix }
      end

      def initialize_cli_connection!
        return if @cli_connection
        raise CliNotAvailableError(cli_tranport_names) unless cli_options_provided?

        # group cli connection options by prefix
        # Our incoming connection options have prefixes, so we see things like 'cli_ssh_host'.
        # The ssh transport wants just 'host'. So identify which transports we have
        # options for, and trim them down.
        known_prefixes = TrainPlugins::Habitat::Transport.cli_transport_prefixes.keys.map(&:to_s)
        seen_cli_transports = transport_options.each_with_object({}) do |xport_option_name, xport_option_value, seen_xports|
          known_prefixes.each do |prefix|
            if xport_option_name.to_s.start_with(prefix)
              xport_name = TrainPlugins::Habitat::Transport.cli_transport_prefixes[prefix]
              seen_xports[xport_name] ||= {}
              # Remove the prefix from the option and store under transport name
              seen_xports[xport_name][xport_option_name.to_s.sub(/^#{prefix}_/,'').to_sym] = xport_option_value
            end
          end
        end

        raise MultipleCliTransportsError.new(seen_cli_tranports.keys) if seen_cli_transports.count > 1

        @cli_transport_name = seen_cli_tranports.keys.first
        @cli_connection = Train.create(cli_transport_name, seen_cli_tranports[cli_tranpoort_name])
      end
    end
  end
end
