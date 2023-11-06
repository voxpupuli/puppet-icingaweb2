require 'spec_helper'

describe('icingaweb2::module::reporting', type: :class) do
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

      context "#{os} with git_revision 'v1.0.0', service_user 'foobaz', mail 'foo@icinga.com'" do
        let(:params) do
          {
            git_revision: 'v1.0.0',
            db_type: 'mysql',
            db_password: 'reporting',
            service_user: 'foobaz',
            mail: 'foo@icinga.com',
          }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('reporting')
            .with_type('mysql')
            .with_host('localhost')
            .with_database('reporting')
            .with_username('reporting')
            .with_password('reporting')
            .with_charset('utf8mb4')
        }

        it {
          is_expected.to contain_icingaweb2__module('reporting')
            .with_install_method('git')
            .with_git_revision('v1.0.0')
            .with_package_name('icingaweb2-module-reporting')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-reporting-backend')
            .with_section_name('backend')
            .with_target('/etc/icingaweb2/modules/reporting/config.ini')
            .with_settings({ 'resource' => 'reporting' })
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-reporting-mail')
            .with_section_name('mail')
            .with_target('/etc/icingaweb2/modules/reporting/config.ini')
            .with_settings({ 'from' => 'foo@icinga.com' })
        }

        it {
          is_expected.to contain_user('foobaz')
            .with_ensure('present')
            .with_gid('bar')
            .with_shell('/bin/false')
        }

        it {
          is_expected.to contain_systemd__unit_file('icinga-reporting.service')
            .with_content(%r{User=foobaz})
            .with_content(%r{ExecStart=/usr/bin/icingacli})
        }

        it {
          is_expected.to contain_service('icinga-reporting')
            .with_ensure('running')
            .with_enable(true)
        }

        it { is_expected.not_to contain_exec('import icingaweb2::module::reporting schema') }
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
          is_expected.to contain_package('icingaweb2-module-reporting')
            .with_ensure('installed')
        }

        it {
          is_expected.to contain_icingaweb2__resource__database('reporting')
            .with_type('mysql')
            .with_host('localhost')
            .with_port(4711)
            .with_database('reporting')
            .with_username('reporting')
            .with_charset('utf8mb4')
        }

        it {
          is_expected.to contain_exec('import icingaweb2::module::reporting schema')
            .with_command(%r{^mysql.*\< '/usr/share/icingaweb2/modules/reporting/schema/mysql.sql'$})
            .with_unless(%r{^mysql.* -Ns -e 'SELECT \* FROM report'$})
        }

        it { is_expected.not_to contain_user('icingareporting') }
        it { is_expected.not_to contain_systemd__unit_file('icinga-reporting.service') }
        it { is_expected.not_to contain_service('icinga-reporting') }
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
          is_expected.to contain_icingaweb2__resource__database('reporting').with(
            {
              'type' => 'mysql',
              'host' => 'localhost',
              'database' => 'reporting',
              'username' => 'reporting',
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
          is_expected.to contain_icingaweb2__resource__database('reporting').with(
            {
              'type' => 'pgsql',
              'host' => 'localhost',
              'database' => 'reporting',
              'username' => 'reporting',
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
          is_expected.to contain_exec('import icingaweb2::module::reporting schema')
            .with_environment(['PGPASSWORD=foo'])
            .with_command(%r{^psql.*-w -f /usr/share/icingaweb2/modules/reporting/schema/postgresql.sql$})
            .with_unless(%r{^psql.*-w -c 'SELECT \* FROM report'$})
        }

        it {
          is_expected.to contain_service('icinga-reporting')
            .with_ensure('stopped')
            .with_enable(false)
        }
      end
    end
  end
end
