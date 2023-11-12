require 'spec_helper'

describe('icingaweb2::module::x509', type: :class) do
  let(:pre_condition) do
    [
      "class { 'icingaweb2': db_type => 'mysql', conf_user => 'foo', conf_group => 'bar'  }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with git_revision 'v1.3.1', service_user 'foobaz'" do
        let(:params) do
          {
            git_revision: 'v1.3.1',
            db_type: 'mysql',
            db_password: 'x509',
            service_user: 'foobaz',
          }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('x509')
            .with_type('mysql')
            .with_host('localhost')
            .with_database('x509')
            .with_username('x509')
            .with_password('x509')
            .with_charset('utf8')
        }

        it {
          is_expected.to contain_icingaweb2__module('x509')
            .with_install_method('git')
            .with_git_revision('v1.3.1')
            .with_package_name('icingaweb2-module-x509')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-x509-backend')
            .with_section_name('backend')
            .with_target('/etc/icingaweb2/modules/x509/config.ini')
            .with_settings({ 'resource' => 'x509' })
        }

        it {
          is_expected.to contain_user('foobaz')
            .with_ensure('present')
            .with_gid('bar')
            .with_shell('/bin/false')
            .with_system(true)
        }

        it {
          is_expected.to contain_systemd__unit_file('icinga-x509.service')
            .with_content(%r{User=foobaz})
            .with_content(%r{ExecStart=/usr/bin/icingacli})
        }

        it {
          is_expected.to contain_service('icinga-x509')
            .with_ensure('running')
            .with_enable(true)
        }

        it { is_expected.not_to contain_exec('import icingaweb2::module::x509 schema') }
      end

      context "#{os} with db_type 'mysql', db_port '4711', install_method 'package', manage_service 'false', import_schema 'true'" do
        let(:params) do
          {
            install_method: 'package',
            manage_service: false,
            db_type: 'mysql',
            db_port: 4711,
            import_schema: true,
          }
        end

        it {
          is_expected.to contain_package('icingaweb2-module-x509')
            .with_ensure('installed')
        }

        it {
          is_expected.to contain_icingaweb2__resource__database('x509')
            .with_type('mysql')
            .with_host('localhost')
            .with_port(4711)
            .with_database('x509')
            .with_username('x509')
            .with_charset('utf8')
        }

        it {
          is_expected.to contain_exec('import icingaweb2::module::x509 schema')
            .with_command(%r{^mysql.*\< '/usr/share/icingaweb2/modules/x509/schema/mysql.schema.sql'$})
            .with_unless(%r{^mysql.* -Ns -e 'SELECT \* FROM x509_certificate'$})
        }

        it {
          is_expected.to contain_user('icingax509')
            .with_ensure('present')
            .with_gid('bar')
            .with_shell('/bin/false')
            .with_system(true)
        }

        it {
          is_expected.to contain_systemd__dropin_file('icinga-x509.conf')
            .with_unit('icinga-x509.service')
            .with_content(%r{User=icingax509})
        }

        it { is_expected.not_to contain_systemd__unit_file('icinga-x509.service') }
        it { is_expected.not_to contain_service('icinga-x509') }
      end

      context "#{os} with use_tls 'true', tls_cacert 'cacert', tls_capath '/foo/bar', tls_noverify 'true', tls_cipher 'cipher'" do
        let(:params) do
          {
            db_type: 'mysql',
            use_tls: true,
            tls_cacert_file: '/foo/bar',
            tls_capath: '/foo/bar',
            tls_noverify: true,
            tls_cipher: 'cipher',
          }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('x509').with(
            {
              'type' => 'mysql',
              'host' => 'localhost',
              'database' => 'x509',
              'username' => 'x509',
              'use_tls' => true,
              'tls_cacert' => '/foo/bar',
              'tls_capath' => '/foo/bar',
              'tls_noverify' => true,
              'tls_cipher' => 'cipher',
            },
          )
        }
      end

      context "#{os} with db_type 'pgsql', use_tls 'true', import_schema 'true', service_ensure 'stopped', service_enabe 'false'" do
        let(:pre_condition) do
          [
            "class { 'icingaweb2': db_type => 'pgsql', tls_cacert_file => '/foo/bar', tls_capath => '/foo/bar', tls_noverify => true, tls_cipher => 'cipher' }",
          ]
        end

        let(:params) do
          {
            db_type: 'pgsql',
            db_password: 'foo',
            import_schema: true,
            use_tls: true,
            service_ensure: 'stopped',
            service_enable: false,
          }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('x509').with(
            {
              'type' => 'pgsql',
              'host' => 'localhost',
              'database' => 'x509',
              'username' => 'x509',
              'password' => 'foo',
              'use_tls' => true,
              'tls_cacert' => '/foo/bar',
              'tls_capath' => '/foo/bar',
              'tls_noverify' => true,
              'tls_cipher' => 'cipher',
              'charset' => 'UTF8',
            },
          )
        }

        it {
          is_expected.to contain_exec('import icingaweb2::module::x509 schema')
            .with_environment(['PGPASSWORD=foo'])
            .with_command(%r{^psql.*-w -f /usr/share/icingaweb2/modules/x509/schema/pgsql.schema.sql$})
            .with_unless(%r{^psql.* -w -c 'SELECT \* FROM x509_certificate'$})
        }

        it {
          is_expected.to contain_service('icinga-x509')
            .with_ensure('stopped')
            .with_enable(false)
        }
      end
    end
  end
end
