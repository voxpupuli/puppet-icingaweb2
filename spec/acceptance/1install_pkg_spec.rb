#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

# These tests are designed to ensure that the module, when ran with defaults,
# sets up everything correctly.
describe 'icingaweb2' do
  it 'with basic settings for package installation' do
    pp = <<-EOS
      class { '::icingaweb2':
        manage_apache_vhost => true,
        manage_repo         => true,
        install_method      => 'package',
      }
    EOS
    apply_manifest(pp, catch_failures: true, debug: false, trace: true)
    apply_manifest(pp, catch_changes: true, debug: false, trace: true)
  end

  describe package('icingaweb2') do
    it { should be_installed }
  end

  describe package('icingacli') do
    it { should be_installed }
  end

  describe service('apache2') do
    it { is_expected.to be_running }
  end

  describe user('icingaweb2') do
    it { should exist }
    it { should belong_to_primary_group 'icingaweb2' }
    # TODO: fix in module
    # it { should_not have_login_shell }
  end

  describe file('/usr/share/icingaweb2') do
    it { should be_directory }
  end

  describe file('/usr/share/icingaweb2/.git') do
    it { should_not exist }
  end
end
