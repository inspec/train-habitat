require 'helper'
require 'logger'
require 'train-habitat'

describe 'Using the SSH CLI transport' do
  let(:transport_opts) do
    {
      # These are determined by the Vagrantfile
      cli_ssh_host: '127.0.0.1',
      cli_ssh_user: 'vagrant',
      cli_ssh_port: '9022',
      cli_ssh_key_files: ['test/integration/shared/.vagrant/machines/default/virtualbox/private_key'],

      # TODO: this gets ignored
      logger: Logger.new(STDOUT, level: :info),
      sudo: true,
    }
  end
  let(:hab_conn) { Train.create(:habitat, transport_opts).connection }

  describe 'when using defaults' do
    it 'should be able to get the hab version' do
      result = hab_conn.run_hab_cli('--version')
      result.exit_status.must_equal 0
      result.stdout.must_match /^hab\s+\d+\.\d+\.\d+\/\d+\n/
    end
  end
end