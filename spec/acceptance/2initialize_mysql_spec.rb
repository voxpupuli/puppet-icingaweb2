#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

# These tests are designed to ensure that the module, when ran with defaults,
# sets up everything correctly.
describe 'icingaweb2' do
  it 'should be able to create database' do
    pp = <<-EOS
      include ::mysql::server

      mysql::db { 'icingaweb2':
        user     => 'icingaweb2',
        password => 'geheim',
        host     => 'localhost',
      }
    EOS
    apply_manifest(pp, catch_failures: true, debug: false, trace: true)
  end

  it 'setup with database' do
    pp = <<-EOS
      class { '::icingaweb2':
        manage_repo    => true,
        install_method => 'package',
        initialize     => true,
        web_db_pass    => 'geheim',
      }
    EOS
    apply_manifest(pp, catch_failures: true, debug: false, trace: true)
    apply_manifest(pp, catch_changes: true, debug: false, trace: true)
  end
end
