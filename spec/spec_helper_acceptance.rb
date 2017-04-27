#! /usr/bin/env ruby -S rspec

# This file comes from puppetlabs-stdlib
# which is licensed under the Apache-2.0 License.
# https://github.com/puppetlabs/puppetlabs-stdlib
# (c) 2015-2015 Puppetlabs and puppetlabs-stdlib contributors

require 'puppet'
require 'puppet/util/package'
require 'beaker-rspec'
require 'beaker/puppet_install_helper'

UNSUPPORTED_PLATFORMS = [].freeze

run_puppet_install_helper

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    if ENV['FUTURE_PARSER'] == 'yes'
      default[:default_apply_opts] ||= {}
      default[:default_apply_opts][:parser] = 'future'
    end

    puppet_version = get_puppet_version
    if Puppet::Util::Package.versioncmp(puppet_version, '4.0.0') < 0
      copy_root_module_to(default, source: proj_root, module_name: 'icingaweb2', target_module_path: '/etc/puppet/modules')
    else
      copy_root_module_to(default, source: proj_root, module_name: 'icingaweb2')
    end

    hosts.each do |host|
      %w(puppetlabs-apt
         puppetlabs-concat
         puppetlabs-stdlib
         puppetlabs-vcsrepo
      ).each do |mod|
        on host, puppet('module', 'install', mod), acceptable_exit_codes: [0, 1]
      end
    end
  end
end

def is_future_parser_enabled?
  # rubocop:disable Style/GuardClause
  if default[:type] == 'aio'
    # rubocop:enable Style/GuardClause
    return true
  elsif default[:default_apply_opts]
    return default[:default_apply_opts][:parser] == 'future'
  end
  false
end

# rubocop:disable Style/AccessorMethodName
def get_puppet_version
  (on default, puppet('--version')).output.chomp
end
# rubocop:enable Style/AccessorMethodName
