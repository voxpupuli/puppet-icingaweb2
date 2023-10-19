require 'spec_helper'

describe('icingaweb2::module::monitoring', type: :class) do
  let(:pre_condition) do
    [
      "class { 'icingaweb2': db_type => 'mysql' }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with ido_type 'mysql' and commandtransport 'api'" do
        let(:params) do
          { ido_type: 'mysql',
            ido_host: 'localhost',
            ido_db_name: 'icinga2',
            ido_db_username: 'icinga2',
            ido_db_password: 'icinga2',
            commandtransports: {
              'foo' => {
                'username' => 'root',
                'password' => 'foobar',
              },
            } }
        end

        it {
          is_expected.to contain_icingaweb2__module('monitoring')
            .with_install_method('none')
            .with_module_dir('/usr/share/icingaweb2/modules/monitoring')
            .with_settings('module-monitoring-backends' => {
                             'section_name' => 'backends',
                             'target' => '/etc/icingaweb2/modules/monitoring/backends.ini',
                             'settings' => {
                               'type' => 'ido',
                               'resource' => 'icingaweb2-module-monitoring',
                             },
                           },
                           'module-monitoring-security' => {
                             'section_name' => 'security',
                             'target' => '/etc/icingaweb2/modules/monitoring/config.ini',
                             'settings' => {
                               'protected_customvars' => '*pw*,*pass*,community',
                             },
                           })
        }

        it {
          is_expected.to contain_icingaweb2__resource__database('icingaweb2-module-monitoring')
            .with_type('mysql')
            .with_host('localhost')
            .with_port('3306')
            .with_database('icinga2')
            .with_username('icinga2')
            .with_password('icinga2')
        }

        it {
          is_expected.to contain_icingaweb2__module__monitoring__commandtransport('foo')
            .with_username('root')
            .with_password('foobar')
        }
      end

      context "#{os} with ido_type 'pgsql' and commandtransport 'local'" do
        let(:params) do
          { ido_type: 'pgsql',
            ido_host: 'localhost',
            ido_port: 5432,
            ido_db_name: 'icinga2',
            ido_db_username: 'icinga2',
            ido_db_password: 'icinga2',
            commandtransports: {
              'foo' => {
                'transport' => 'local',
              },
            } }
        end

        it do
          is_expected.to contain_icingaweb2__module('monitoring')
            .with_install_method('none')
            .with_module_dir('/usr/share/icingaweb2/modules/monitoring')
            .with_settings('module-monitoring-backends' => {
                             'section_name' => 'backends',
                             'target' => '/etc/icingaweb2/modules/monitoring/backends.ini',
                             'settings' => {
                               'type' => 'ido',
                               'resource' => 'icingaweb2-module-monitoring',
                             },
                           },
                           'module-monitoring-security' => {
                             'section_name' => 'security',
                             'target' => '/etc/icingaweb2/modules/monitoring/config.ini',
                             'settings' => {
                               'protected_customvars' => '*pw*,*pass*,community',
                             },
                           })
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('icingaweb2-module-monitoring')
            .with_type('pgsql')
            .with_host('localhost')
            .with_port(5432)
            .with_database('icinga2')
            .with_username('icinga2')
            .with_password('icinga2')
        }

        it {
          is_expected.to contain_icingaweb2__module__monitoring__commandtransport('foo')
            .with_transport('local')
        }
      end

      context "#{os} with invalid ido_type" do
        let(:params) { { ido_type: 'foobar' } }

        it { is_expected.to raise_error(Puppet::Error, %r{expects a match for Enum\['mysql', 'pgsql'\]}) }
      end

      context "#{os} with array protected_customvars" do
        let(:params) do
          { ido_type: 'mysql',
            ido_host: 'localhost',
            ido_db_name: 'icinga2',
            ido_db_username: 'icinga2',
            ido_db_password: 'icinga2',
            commandtransports: {
              'foo' => {
                'transport' => 'local',
              },
            },
            protected_customvars: ['foo', 'bar', '*baz*'] }
        end

        it {
          is_expected.to contain_icingaweb2__module('monitoring')
            .with_settings('module-monitoring-backends' => {
                             'section_name' => 'backends',
                             'target' => '/etc/icingaweb2/modules/monitoring/backends.ini',
                             'settings' => {
                               'type' => 'ido',
                               'resource' => 'icingaweb2-module-monitoring',
                             },
                           },
                           'module-monitoring-security' => {
                             'section_name' => 'security',
                             'target' => '/etc/icingaweb2/modules/monitoring/config.ini',
                             'settings' => {
                               'protected_customvars' => 'foo,bar,*baz*',
                             },
                           })
        }
      end
    end
  end
end
