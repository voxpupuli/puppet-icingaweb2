require 'spec_helper'

describe('icingaweb2::module::vspheredb', type: :class) do
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

      context "#{os} with git_revision 'v1.7.1', service_user 'foobaz'" do
        let(:params) do
          {
            git_revision: 'v1.7.1',
            db_type: 'mysql',
            db_password: 'vspheredb',
            service_user: 'foobaz',
          }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('icingaweb2-module-vspheredb')
            .with_type('mysql')
            .with_host('localhost')
            .with_database('vspheredb')
            .with_username('vspheredb')
            .with_password('vspheredb')
            .with_charset('utf8mb4')
        }

        it {
          is_expected.to contain_icingaweb2__module('vspheredb')
            .with_install_method('git')
            .with_git_revision('v1.7.1')
            .with_package_name('icingaweb2-module-vspheredb')
            .with_settings('icingaweb2-module-vspheredb' => {
                             'section_name' => 'db',
                             'target' => '/etc/icingaweb2/modules/vspheredb/config.ini',
                             'settings' => {
                               'resource' => 'icingaweb2-module-vspheredb',
                             },
                           })
        }

        it {
          is_expected.to contain_user('foobaz')
            .with_ensure('present')
            .with_gid('bar')
            .with_shell('/bin/false')
        }

        it {
          is_expected.to contain_systemd__tmpfile('icinga-vspheredb.conf')
            .with_content(%r{/run/icinga-vspheredb 0755 foobaz bar -})
        }

        it {
          is_expected.to contain_systemd__unit_file('icinga-vspheredb.service')
            .with_content(%r{User=foobaz})
            .with_content(%r{ExecStart=/usr/bin/icingacli})
        }

        it {
          is_expected.to contain_service('icinga-vspheredb')
            .with_ensure('running')
            .with_enable(true)
        }

        it { is_expected.not_to contain_exec('import icingaweb2::module::vspheredb schema') }
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
          is_expected.to contain_package('icingaweb2-module-vspheredb')
            .with_ensure('installed')
        }

        it {
          is_expected.to contain_icingaweb2__resource__database('icingaweb2-module-vspheredb')
            .with_type('mysql')
            .with_host('localhost')
            .with_port(4711)
            .with_database('vspheredb')
            .with_username('vspheredb')
            .with_charset('utf8mb4')
        }

        it {
          is_expected.to contain_exec('import icingaweb2::module::vspheredb schema')
            .with_command(%r{^mysql.*\< '/usr/share/icingaweb2/modules/vspheredb/schema/mysql.sql'$})
            .with_unless(%r{^mysql.*-Ns -e 'SELECT schema_version FROM vspheredb_schema_migration'$})
        }

        it { is_expected.not_to contain_user('icingavspheredb') }
        it { is_expected.not_to contain_systemd__tmpfile('icinga-vspheredb.conf') }
        it { is_expected.not_to contain_systemd__unit_file('icinga-vspheredb.service') }
        it { is_expected.not_to contain_service('icinga-vspheredb') }
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
          is_expected.to contain_icingaweb2__resource__database('icingaweb2-module-vspheredb').with(
            {
              'type' => 'mysql',
              'host' => 'localhost',
              'database' => 'vspheredb',
              'username' => 'vspheredb',
              'use_tls' => true,
              'tls_cacert' => '/foo/bar',
              'tls_capath' => '/foo/bar',
              'tls_noverify' => true,
              'tls_cipher' => 'cipher',
            },
          )
        }
      end

      context "#{os} with use_tls 'true', service_ensure 'stopped', service_enabe 'false'" do
        let(:pre_condition) do
          [
            "class { 'icingaweb2': db_type => 'mysql', tls_cacert_file => '/foo/bar', tls_capath => '/foo/bar', tls_noverify => true, tls_cipher => 'cipher' }",
          ]
        end

        let(:params) do
          {
            db_type: 'mysql',
            use_tls: true,
            service_ensure: 'stopped',
            service_enable: false,
          }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('icingaweb2-module-vspheredb').with(
            {
              'type' => 'mysql',
              'host' => 'localhost',
              'database' => 'vspheredb',
              'username' => 'vspheredb',
              'use_tls' => true,
              'tls_cacert' => '/foo/bar',
              'tls_capath' => '/foo/bar',
              'tls_noverify' => true,
              'tls_cipher' => 'cipher',
            },
          )
        }

        it {
          is_expected.to contain_service('icinga-vspheredb')
            .with_ensure('stopped')
            .with_enable(false)
        }
      end
    end
  end
end
