require './test/helper'

describe TrainPlugins::Habitat::Connection, 'Train Habitat Connection' do
  let(:opt) { { host: 'habitat01.inspec.io' } }

  subject { TrainPlugins::Habitat::Connection.new(opt) }

  it '#new' do
    subject.must_be_kind_of TrainPlugins::Habitat::Connection

    proc do
      TrainPlugins::Habitat::Connection.new({})
    end.must_raise Train::TransportError
  end

  it '#uri' do
    subject.uri.must_equal 'habitat://habitat01.inspec.io'
  end

  it '#habitat_client' do
    subject.habitat_client.must_be_kind_of TrainPlugins::Habitat::HTTPGateway
  end

  describe TrainPlugins::Habitat::HTTPGateway do
    subject { TrainPlugins::Habitat::HTTPGateway.new(opt[:host]) }

    it '#new' do
      subject.must_be_kind_of TrainPlugins::Habitat::HTTPGateway
      subject.uri.must_be_kind_of URI
    end

    it '#services' do
      skip
    end
  end
end
