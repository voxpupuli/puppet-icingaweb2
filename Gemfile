source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? "~> #{ENV['PUPPET_VERSION']}" : ['>= 3.7.4']
gem 'puppet', puppetversion

if puppetversion =~ /^3/
  ## rspec-hiera-puppet is puppet 3 only
  gem 'rspec-hiera-puppet', '>=1.0.0'
end

facterversion = ENV.key?('FACTER_VERSION') ? "~> #{ENV['FACTER_VERSION']}" : ['>= 2.4.1']

gem 'facter', facterversion

gem 'rake'
gem 'rspec'
gem 'puppet-lint', '>=1.1.0'
gem 'rspec-puppet', :git => 'https://github.com/rodjek/rspec-puppet.git'
gem 'puppetlabs_spec_helper', '>=0.8.2'
gem 'puppet-syntax'

