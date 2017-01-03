source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gem 'puppet', ENV.key?('PUPPET_VERSION') ? ENV['PUPPET_VERSION'].to_s : '>= 2.7'
gem 'rspec-puppet', '~> 2.0'
gem 'puppetlabs_spec_helper', '>= 0.1.0'
gem 'puppet-lint', '>= 2'
gem 'facter', '>= 1.7.0'
gem 'metadata-json-lint'

json_version = ENV.key?('TRAVIS_RUBY_VERSION') && ENV['TRAVIS_RUBY_VERSION'].to_i < 2 ? '~> 1.8.3' : '~> 2.0'
gem 'json', json_version
gem 'json_pure', json_version

gem 'puppet-lint-strict_indent-check'
