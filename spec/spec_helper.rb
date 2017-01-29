require 'rubygems'
require 'rspec-puppet'
require 'mocha/api'

require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')
  c.mock_with :mocha

  default_facts = {
    puppetversion: Puppet.version,
    facterversion: Facter.version
  }
  default_facts.merge!(YAML.load(File.read(File.expand_path('../default_facts.yml', __FILE__)))) if File.exist?(File.expand_path('../default_facts.yml', __FILE__))
  default_facts.merge!(YAML.load(File.read(File.expand_path('../default_module_facts.yml', __FILE__)))) if File.exist?(File.expand_path('../default_module_facts.yml', __FILE__))
  c.default_facts = default_facts

  at_exit { RSpec::Puppet::Coverage.report! }
end

def centos_facts
  {
    :operatingsystem        => 'CentOS',
    :osfamily               => 'RedHat',
    :operatingsystemrelease => '6',
  }
end

def debian_facts
  {
    :operatingsystem        => 'Debian',
    :osfamily               => 'Debian',
    :operatingsystemrelease => '7',
  }
end
