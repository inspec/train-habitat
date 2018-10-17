# frozen_string_literal: true

require './test/helper'
require './lib/train-habitat/connection'

# rubocop:disable Metrics/BlockLength
describe TrainPlugins::Habitat::Connection do
  subject { TrainPlugins::Habitat::Connection }

  let(:opt)  { { host: 'habitat01.inspec.io' } }
  let(:conn) { subject.new(opt) }

  describe 'connection definition' do
    it 'should inherit from the Train Connection base' do
      # For Class, '<' means 'is a descendant of'
      (subject < Train::Plugins::Transport::BaseConnection).must_equal(true)
    end

    # Since this is an API-type connection, we do not implement these three.
    %i(
      file_via_connection
      run_command_via_connection
      local?
    ).each do |method_name|
      it "should NOT provide a #{method_name}() method" do
        # false passed to instance_methods says 'don't use inheritance'
        subject.instance_methods(false).wont_include(method_name)
      end
    end

    # Ensure Train knows this is not local.
    it 'should declare itself as a non-local transport' do
      subject.new(opt).local?.must_equal(false)
    end
  end

  describe '#new' do
    it 'should raise Train::Transport error with empty options' do
      proc do
        TrainPlugins::Habitat::Connection.new({})
      end.must_raise Train::TransportError
    end
  end

  describe '#uri' do
    it 'should have the correct habitat uri' do
      conn.uri.must_equal 'habitat://habitat01.inspec.io'
    end
  end

  describe '#habitat_client' do
    it 'should return kind of TrainPlugins::Habitat::HTTPGateway' do
      conn.habitat_client.must_be_kind_of TrainPlugins::Habitat::HTTPGateway
    end
  end

  describe TrainPlugins::Habitat::HTTPGateway do
    subject { TrainPlugins::Habitat::HTTPGateway.new(opt[:host]) }

    it '#new' do
      subject.must_be_kind_of TrainPlugins::Habitat::HTTPGateway
      subject.uri.must_be_kind_of URI
    end
  end
end
