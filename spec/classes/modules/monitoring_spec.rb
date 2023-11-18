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
            ido_port: 4711,
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
            .with_ensure('present')
            .with_install_method('none')
            .with_module_dir('/usr/share/icingaweb2/modules/monitoring')
            .with_settings({})
        }

        it {
          is_expected.to contain_icingaweb2__inisection('module-monitoring-backends')
            .with_section_name('backends')
            .with_target('/etc/icingaweb2/modules/monitoring/backends.ini')
            .with_settings({ 'type' => 'ido', 'resource' => 'icinga2' })
        }

        it {
          is_expected.to contain_icingaweb2__inisection('module-monitoring-security')
            .with_section_name('security')
            .with_target('/etc/icingaweb2/modules/monitoring/config.ini')
            .with_settings({ 'protected_customvars' => '*pw*,*pass*,community', })
        }

        it {
          is_expected.to contain_icingaweb2__resource__database('icinga2')
            .with_type('mysql')
            .with_host('localhost')
            .with_port(4711)
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

      context "#{os} with ido_type 'pgsql', ido_resource_name 'foobar'  and commandtransport 'local'" do
        let(:params) do
          { ido_type: 'pgsql',
            ido_resource_name: 'foobar',
            ido_host: 'localhost',
            ido_db_name: 'icinga2',
            ido_db_username: 'icinga2',
            ido_db_password: 'icinga2',
            commandtransports: {
              'foo' => {
                'transport' => 'local',
              },
            } }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('module-monitoring-backends')
            .with_section_name('backends')
            .with_target('/etc/icingaweb2/modules/monitoring/backends.ini')
            .with_settings({ 'type' => 'ido', 'resource' => 'foobar' })
        }

        it {
          is_expected.to contain_icingaweb2__resource__database('foobar')
            .with_type('pgsql')
            .with_host('localhost')
            .with_database('icinga2')
            .with_username('icinga2')
            .with_password('icinga2')
        }

        it {
          is_expected.to contain_icingaweb2__module__monitoring__commandtransport('foo')
            .with_transport('local')
        }
      end

      context "#{os} with array protected_customvars and API commandtransport" do
        let(:params) do
          { ido_type: 'mysql',
            ido_host: 'localhost',
            ido_db_name: 'icinga2',
            ido_db_username: 'icinga2',
            ido_db_password: 'icinga2',
            commandtransports: {
              'foo' => {
                'transport' => 'api',
                'host' => 'api.icinga.com',
                'port' => 4711,
                'username' => 'icingaweb2',
                'password' => 'secret',
              },
            },
            protected_customvars: ['foo', 'bar', '*baz*'] }
        end

        it {
          is_expected.to contain_icingaweb2__module__monitoring__commandtransport('foo')
            .with_transport('api')
            .with_host('api.icinga.com')
            .with_port(4711)
            .with_username('icingaweb2')
            .with_password('secret')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('module-monitoring-security')
            .with_section_name('security')
            .with_target('/etc/icingaweb2/modules/monitoring/config.ini')
            .with_settings({ 'protected_customvars' => 'foo,bar,*baz*' })
        }
      end

      context "#{os} with use_tls 'true', tls_cacert 'cacert', tls_capath '/foo/bar', tls_noverify 'true', tls_cipher 'cipher'" do
        let(:params) do
          {
            ido_type: 'pgsql',
            use_tls: true,
            tls_cacert_file: '/foo/bar',
            tls_capath: '/foo/bar',
            tls_noverify: true,
            tls_cipher: 'cipher',
          }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('icinga2').with(
            {
              'type' => 'pgsql',
              'host' => 'localhost',
              'database' => 'icinga2',
              'username' => 'icinga2',
              'use_tls' => true,
              'tls_cacert' => '/foo/bar',
              'tls_capath' => '/foo/bar',
              'tls_noverify' => true,
              'tls_cipher' => 'cipher',
            },
          )
        }
      end

      context "#{os} with use_tls 'true'" do
        let(:pre_condition) do
          [
            "class { 'icingaweb2': db_type => 'mysql', tls_cacert_file => '/foo/bar', tls_capath => '/foo/bar', tls_noverify => true, tls_cipher => 'cipher' }",
          ]
        end

        let(:params) do
          {
            ido_type: 'mysql',
            use_tls: true,
          }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('icinga2').with(
            {
              'type' => 'mysql',
              'host' => 'localhost',
              'database' => 'icinga2',
              'username' => 'icinga2',
              'use_tls' => true,
              'tls_cacert' => '/foo/bar',
              'tls_capath' => '/foo/bar',
              'tls_noverify' => true,
              'tls_cipher' => 'cipher',
            },
          )
        }
      end
    end
  end
end
