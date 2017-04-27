#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

# These tests are designed to ensure that the module, when ran with defaults,
# sets up everything correctly.
describe 'icingaweb2' do
  it 'with basic settings for package installation' do
    pp = <<-EOS
      class { '::icingaweb2':
        manage_repo    => true,
      }
    EOS
    apply_manifest(pp, catch_failures: true, debug: false, trace: true)
    apply_manifest(pp, catch_changes: true, debug: false, trace: true)
  end

  describe package('icingaweb2') do
    it { should be_installed }
  end

  describe service('apache2') do
    it { is_expected.to be_running }
  end
end
