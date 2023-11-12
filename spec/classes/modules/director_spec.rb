require 'spec_helper'

describe('icingaweb2::module::director', type: :class) do
  let(:pre_condition) do
    [
      "class { 'icingaweb2': db_type => 'mysql', conf_user => 'foo', conf_group => 'bar' }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with kickstart 'true'" do
        let(:params) do
          { git_revision: 'foobar',
            db_type: 'mysql',
            db_host: 'localhost',
            db_name: 'director',
            db_username: 'director',
            db_password: 'director',
            import_schema: true,
            service_user: 'foobaz',
            kickstart: true,
            endpoint: 'foobar',
            api_username: 'root',
            api_password: 'secret' }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('icingaweb2-module-director')
            .with_type('mysql')
            .with_host('localhost')
            .with_database('director')
            .with_username('director')
            .with_password('director')
            .with_charset('utf8')
        }

        it {
          is_expected.to contain_icingaweb2__module('director')
            .with_install_method('git')
            .with_git_revision('foobar')
            .with_module_dir('/usr/share/icingaweb2/modules/director')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('module-director-db')
            .with_section_name('db')
            .with_target('/etc/icingaweb2/modules/director/config.ini')
            .with_settings({ 'resource' => 'icingaweb2-module-director' })
        }

        it {
          is_expected.to contain_icingaweb2__inisection('module-director-config')
            .with_section_name('config')
            .with_target('/etc/icingaweb2/modules/director/kickstart.ini')
            .with_settings({ 'endpoint' => 'foobar', 'host' => 'localhost', 'port' => '5665', 'username' => 'root', 'password' => 'secret' })
        }

        it {
          is_expected.to contain_user('foobaz')
            .with_ensure('present')
            .with_gid('bar')
            .with_shell('/bin/false')
            .with_system(true)
        }

        it {
          is_expected.to contain_systemd__unit_file('icinga-director.service')
            .with_content(%r{User=foobaz})
            .with_content(%r{ExecStart=/usr/bin/icingacli})
        }

        it {
          is_expected.to contain_service('icinga-director')
            .with_ensure('running')
            .with_enable(true)
        }

        it { is_expected.to contain_exec('director-migration') }
        it { is_expected.to contain_exec('director-kickstart') }
      end

      context "#{os} with import_schema 'false', install_method 'package', manage_service 'false'" do
        let(:params) do
          { git_revision: 'foobar',
            db_type: 'mysql',
            db_host: 'localhost',
            db_name: 'director',
            db_username: 'director',
            db_password: 'director',
            install_method: 'package',
            manage_service: false,
            import_schema: false }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('icingaweb2-module-director')
            .with_type('mysql')
            .with_host('localhost')
            .with_database('director')
            .with_username('director')
            .with_password('director')
            .with_charset('utf8')
        }

        it {
          is_expected.to contain_icingaweb2__module('director')
            .with_install_method('package')
            .with_module_dir('/usr/share/icingaweb2/modules/director')
        }

        it {
          is_expected.to contain_user('icingadirector')
            .with_ensure('present')
            .with_gid('bar')
            .with_shell('/bin/false')
            .with_system(true)
        }

        it {
          is_expected.to contain_systemd__dropin_file('icinga-director.conf')
            .with_unit('icinga-director.service')
            .with_content(%r{User=icingadirector})
        }

        it { is_expected.not_to contain_systemd__unit_file('icinga-director.service') }
        it { is_expected.not_to contain_service('icinga-director') }
        it { is_expected.not_to contain_exec('director-migration') }
        it { is_expected.not_to contain_exec('director-kickstart') }
      end

      context "#{os} with use_tls 'true', tls_cacert 'cacert', tls_capath '/foo/bar', tls_noverify 'true', tls_cipher 'cipher'" do
        let(:params) do
          {
            db_type: 'pgsql',
            use_tls: true,
            tls_cacert_file: '/foo/bar',
            tls_capath: '/foo/bar',
            tls_noverify: true,
            tls_cipher: 'cipher',
          }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('icingaweb2-module-director').with(
            {
              'type' => 'pgsql',
              'host' => 'localhost',
              'database' => 'director',
              'username' => 'director',
              'charset' => 'UTF8',
              'use_tls' => true,
              'tls_cacert' => '/foo/bar',
              'tls_capath' => '/foo/bar',
              'tls_noverify' => true,
              'tls_cipher' => 'cipher',
            },
          )
        }
      end

      context "#{os} with use_tls 'true', db_port '4711'" do
        let(:pre_condition) do
          [
            "class { 'icingaweb2': db_type => 'mysql', tls_cacert_file => '/foo/bar', tls_capath => '/foo/bar', tls_noverify => true, tls_cipher => 'cipher' }",
          ]
        end

        let(:params) do
          {
            db_type: 'mysql',
            db_port: 4711,
            use_tls: true,
          }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('icingaweb2-module-director').with(
            {
              'type' => 'mysql',
              'host' => 'localhost',
              'port' => 4711,
              'database' => 'director',
              'username' => 'director',
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
