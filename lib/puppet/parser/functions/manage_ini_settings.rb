#
# manage_ini_settings.rb
#
# This code is copied from the original puppetlabs/inifile module.
# The original function 'create_ini_settings' lacked an option to override the 'ensure' parameter.
# Code of the original function:
# https://github.com/puppetlabs/puppetlabs-inifile/blob/master/lib/puppet/parser/functions/create_ini_settings.rb
#

module Puppet::Parser::Functions
  newfunction(:manage_ini_settings, :type => :statement, :doc => <<-EOS
Uses create_resources to create a set of ini_setting resources from a hash:
    $settings = {  section1 => {
        setting1 => val1
      },
      section2 => {
        setting2 => val2,
        setting3 => {
          ensure => absent
        }
      }
    }
    $defaults = {
      path => '/tmp/foo.ini'
    }
    manage_ini_settings($settings,$defaults)
Will create the following resources
    ini_setting{'/tmp/foo.ini [section1] setting1':
      ensure  => present,
      section => 'section1',
      setting => 'setting1',
      value   => 'val1',
      path    => '/tmp/foo.ini',
    }
    ini_setting{'/tmp/foo.ini [section2] setting2':
      ensure  => present,
      section => 'section2',
      setting => 'setting2',
      value   => 'val2',
      path    => '/tmp/foo.ini',
    }
    ini_setting{'/tmp/foo.ini [section2] setting3':
      ensure  => absent,
      section => 'section2',
      setting => 'setting3',
      path    => '/tmp/foo.ini',
    }
  EOS
  ) do |arguments|

    raise(Puppet::ParseError, "manage_ini_settings(): Wrong number of arguments " +
        "given (#{arguments.size} for 1 or 2)") unless arguments.size.between?(1,2)

    settings = arguments[0]
    defaults = arguments[1] || {}

    if [settings,defaults].any?{|i| !i.is_a?(Hash) }
      raise(Puppet::ParseError,
            'manage_ini_settings(): Requires all arguments to be a Hash')
    end

    resources = settings.keys.inject({}) do |res, section|
      raise(Puppet::ParseError,
            "manage_ini_settings(): Section #{section} must contain a Hash") \
        unless settings[section].is_a?(Hash)

      unless path = defaults.merge(settings)['path']
        raise Puppet::ParseError, 'manage_ini_settings(): must pass the path parameter to the Ini_setting resource!'
      end

      unless manage = defaults.merge(settings)['ensure']
        raise Puppet::ParseError, 'manage_ini_settings(): must pass the ensure parameter to the Ini_setting resource!'
      end

      settings[section].each do |setting, value|
        res["#{manage} #{path} [#{section}] #{setting}"] = {
            'section' => section,
            'setting' => setting,
        }.merge(if value.is_a?(Hash)
                  value
                else
                  { 'value'   => value, }
                end)
      end
      res
    end

    Puppet::Parser::Functions.function('create_resources')
    function_create_resources(['ini_setting',resources,defaults])
  end
end

# vim: set ts=2 sw=2 et :