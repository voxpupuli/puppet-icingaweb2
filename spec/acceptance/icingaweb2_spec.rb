# frozen_string_literal: true

require 'spec_helper_acceptance'

# packages.icinga.com only serves RHEL-family packages to subscribers
describe 'icingaweb2', if: fact('os.family') == 'Debian' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<~PUPPET
        class { 'icinga::repos':
          manage_stable => true,
        }
        class { 'icingaweb2':
          manage_repos => true,
          db_type      => 'mysql',
        }
      PUPPET
    end
  end

  describe package('icingaweb2') do
    it { is_expected.to be_installed }
  end

  describe file('/etc/icingaweb2/config.ini') do
    its(:content) { is_expected.to match %r{^\[logging\]} }
  end

  describe file('/etc/icingaweb2/resources.ini') do
    its(:content) { is_expected.to match %r{^\[icingaweb2\]} }
  end
end
