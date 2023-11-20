require 'spec_helper'

describe('icingaweb2', type: :class) do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context "#{os} with db_type 'mysql'" do
        let(:params) { { db_type: 'mysql' } }

        it { is_expected.to compile }
        it { is_expected.to contain_class('icingaweb2::config') }
        it { is_expected.to contain_class('icingaweb2::install') }
        it { is_expected.not_to contain_class('icinga::repos') }

        it { is_expected.to contain_package('icingaweb2').with('ensure' => 'installed') }
        [ '/etc/icingaweb2/modules',
          '/etc/icingaweb2/enabledModules',
          '/etc/icingaweb2/navigation',
          '/etc/icingaweb2/dashboards',
          '/var/lib/icingaweb2/certs' ].each do |file|
          it {
            is_expected.to contain_file(file)
              .with_ensure('directory')
              .with_mode('2770')
              .with_owner('root')
              .with_group('icingaweb2')
          }
        end
        it {
          is_expected.to contain_icingaweb2__inisection('config-logging')
            .with_section_name('logging')
            .with_target('/etc/icingaweb2/config.ini')
            .with_settings(
              {
                'log' => 'syslog',
                'file' => '/var/log/icingaweb2/icingaweb2.log',
                'level' => 'INFO',
                'facility' => 'user',
                'application' => 'icingaweb2',
              },
            )
        }
        it {
          is_expected.to contain_icingaweb2__inisection('config-global')
            .with_section_name('global')
            .with_target('/etc/icingaweb2/config.ini')
            .with_settings(
              {
                'show_stacktraces' => false,
                 'module_path' => '/usr/share/icingaweb2/modules',
                 'config_resource' => 'icingaweb2',
              },
            )
        }
        it {
          is_expected.to contain_icingaweb2__inisection('config-themes')
            .with_section_name('themes')
            .with_target('/etc/icingaweb2/config.ini')
            .with_settings(
              {
                'default' => 'Icinga',
                'disabled' => false,
              },
            )
        }
        it { is_expected.not_to contain_icingaweb2__inisection('config-authentication') }
        it { is_expected.not_to contain_icingaweb2__inisection('config-cookie') }
        it {
          is_expected.to contain_icingaweb2__resource__database('icingaweb2')
            .with_type('mysql')
            .with_host('localhost')
            .with_port(3306)
            .with_database('icingaweb2')
            .with_username('icingaweb2')
        }

        it {
          is_expected.to contain_icingaweb2__config__authmethod('Icinga Web 2')
            .with_backend('db')
            .with_resource('icingaweb2')
        }

        it {
          is_expected.to contain_icingaweb2__config__groupbackend('Icinga Web 2')
            .with_backend('db')
            .with_resource('icingaweb2')
        }

        it { is_expected.not_to contain_exec('import schema') }
        it { is_expected.not_to contain_exec('create default admin user') }
        it { is_expected.not_to contain_icingaweb2__config__role('default admin user') }
      end

      context "#{os} with manage_package 'false', cookie_path '/foo/bar', default_domain 'foobar'" do
        let(:params) do
          {
            manage_package: false,
            cookie_path: '/foo/bar',
            default_domain: 'foobar',
            db_type: 'mysql',
          }
        end

        it { is_expected.not_to contain_package('icinga2').with('ensure' => 'installed') }
        it {
          is_expected.to contain_icingaweb2__inisection('config-cookie')
            .with_section_name('cookie')
            .with_target('/etc/icingaweb2/config.ini')
            .with_settings({ 'path' => '/foo/bar' })
        }
        it {
          is_expected.to contain_icingaweb2__inisection('config-authentication')
            .with_section_name('authentication')
            .with_target('/etc/icingaweb2/config.ini')
            .with_settings({ 'default_domain' => 'foobar' })
        }
      end

      context "#{os} with default_auth_backend 'false', additional resources, user and group backend" do
        let(:params) do
          {
            db_type: 'mysql',
            resources: {
              foo: { type: 'ldap' },
              baz: { type: 'pgsql', host: 'localhost', database: 'baz', port: 5432 },
            },
            default_auth_backend: false,
            user_backends: {
              bar: { backend: 'ldap', resource: 'foo' },
            },
            group_backends: {
              bar: { backend: 'ldap', resource: 'foo' },
            },
          }
        end

        it { is_expected.not_to contain_icingaweb2__config__authmethod('Icinga Web 2') }
        it { is_expected.not_to contain_icingaweb2__config__groupbackend('Icinga Web 2') }
        it { is_expected.to contain_icingaweb2__resource__ldap('foo') }
        it { is_expected.to contain_icingaweb2__resource__database('baz').with('type' => 'pgsql') }
        it { is_expected.to contain_icingaweb2__config__authmethod('bar').with('resource' => 'foo') }
        it { is_expected.to contain_icingaweb2__config__groupbackend('bar').with('resource' => 'foo') }
      end

      context "#{os} with db_type 'mysql', import_schema 'true'" do
        let(:params) { { import_schema: true, db_type: 'mysql' } }

        it { is_expected.to contain_icingaweb2__resource__database('icingaweb2') }
        it { is_expected.to contain_icingaweb2__config__role('default admin user') }
        it { is_expected.to contain_exec('import schema') }
        it { is_expected.to contain_exec('create default admin user') }
      end

      context "#{os} with db_type 'pgsql', db_resource_name 'foobar', import_schema 'true', default_auth_backend 'foobaz'" do
        let(:params) do
          {
            db_type: 'pgsql',
            import_schema: true,
            db_resource_name: 'foobar',
            default_auth_backend: 'foobaz',
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('config-global')
            .with_section_name('global')
            .with_target('/etc/icingaweb2/config.ini')
            .with_settings(
              {
                'show_stacktraces' => false,
                 'module_path' => '/usr/share/icingaweb2/modules',
                 'config_resource' => 'foobar',
              },
            )
        }

        it {
          is_expected.to contain_icingaweb2__config__authmethod('foobaz')
            .with_backend('db')
            .with_resource('foobar')
        }

        it {
          is_expected.to contain_icingaweb2__config__groupbackend('foobaz')
            .with_backend('db')
            .with_resource('foobar')
        }

        it { is_expected.to contain_icingaweb2__config__role('default admin user') }
        it { is_expected.to contain_icingaweb2__resource__database('foobar') }
        it { is_expected.to contain_exec('import schema') }
        it { is_expected.to contain_exec('create default admin user') }
      end

      context "#{os} with import_schema 'true' and admin_role 'false'" do
        let(:params) { { import_schema: true, db_type: 'mysql', admin_role: false } }

        it { is_expected.not_to contain_icingaweb2__config__role('default admin user') }
      end
    end
  end
end
