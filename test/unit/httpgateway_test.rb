require './test/helper'
require './lib/train-habitat/httpgateway'

describe TrainPlugins::Habitat::HTTPGateway do # rubocop: disable Metrics/BlockLength
  let(:hgw) { TrainPlugins::Habitat::HTTPGateway.new(opts) }
  describe 'when a full URL is provided' do
    let(:opts) { { url: 'http://habitat01.inspec.io:9631', } }

    it 'should make the proper object' do
      hgw.must_be_kind_of TrainPlugins::Habitat::HTTPGateway
    end

    it 'should make a base URI' do
      hgw.base_uri.must_be_kind_of URI
      hgw.base_uri.to_s.must_equal opts[:url]
    end

    # it 'should accept paths'
    # it 'should automatically unpack JSON responses'
  end

  describe 'when a URL without port is provided' do
    let(:opts) { { url: 'http://habitat01.inspec.io', } }

    it 'assumes port 9631' do
      hgw.base_uri.port.must_equal 9631
    end
  end
end

