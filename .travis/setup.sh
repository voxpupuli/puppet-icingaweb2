#!/bin/sh

# To ensure compatibility with Ruby 2.1 and Puppet 4
# we are only updating gem for later versions.

# Source:
# https://github.com/voxpupuli/puppet-php/blob/f20e20d3558f139ed8778a902ed505636204dbaa/.travis/setup.sh

rm -f Gemfile.lock
if [ "${PUPPET_VERSION}" = '~> 4.0' ]; then
  gem install bundler -v '< 2' --no-rdoc --no-ri;
else
  gem update --system;
  gem update bundler;
  bundle --version;
fi
