require 'spec_helper'

describe('icingaweb2::module::reporting', type: :class) do
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

      context "#{os} with db_type 'mysql'" do
        let(:params) do
          { git_revision: 'foobar',
            db_type: 'mysql' }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('reporting')
            .with_type('mysql')
            .with_host('localhost')
            .with_database('reporting')
            .with_username('reporting')
            .with_charset('utf8mb4')
        }

        it {
          is_expected.to contain_icingaweb2__module('reporting')
            .with_install_method('git')
            .with_git_revision('foobar')
            .with_module_dir('/usr/share/icingaweb2/modules/reporting')
            .with_settings('icingaweb2-module-reporting-backend' => {
                             'section_name' => 'backend',
                             'target' => '/etc/icingaweb2/modules/reporting/config.ini',
                             'settings' => {
                               'resource' => 'reporting',
                             },
                           },
                           'icingaweb2-module-reporting-mail' => {
                             'section_name' => 'mail',
                             'target' => '/etc/icingaweb2/modules/reporting/config.ini',
                             'settings' => {},
                           })
        }

        it { is_expected.not_to contain_exec('import icingaweb2::module::reporting schema') }

        it {
          is_expected.to contain_class('icingaweb2::module::reporting::service')
            .with_ensure('running')
            .with_enable(true)
        }
      end

      context "#{os} with db_type 'mysql', import_schema 'true'" do
        let(:params) do
          { db_type: 'mysql',
            import_schema: true }
        end

        it { is_expected.to contain_exec('import icingaweb2::module::reporting schema') }
      end

      context "#{os} with db_type 'pgsql', mail 'foobar@examle.com', manage_service 'false', install_method 'package'" do
        let(:params) do
          { install_method: 'package',
            db_type: 'pgsql',
            manage_service: false,
            mail: 'foobar@example.com' }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('reporting')
            .with_type('pgsql')
            .with_host('localhost')
            .with_database('reporting')
            .with_username('reporting')
            .with_charset('UTF8')
        }

        it {
          is_expected.to contain_icingaweb2__module('reporting')
            .with_install_method('package')
            .with_package_name('icingaweb2-module-reporting')
            .with_module_dir('/usr/share/icingaweb2/modules/reporting')
            .with_settings('icingaweb2-module-reporting-backend' => {
                             'section_name' => 'backend',
                             'target' => '/etc/icingaweb2/modules/reporting/config.ini',
                             'settings' => {
                               'resource' => 'reporting',
                             },
                           },
                           'icingaweb2-module-reporting-mail' => {
                             'section_name' => 'mail',
                             'target' => '/etc/icingaweb2/modules/reporting/config.ini',
                             'settings' => {
                               'from' => 'foobar@example.com',
                             },
                           })
        }

        it { is_expected.not_to contain_exec('import icingaweb2::module::reporting schema') }
        it { is_expected.not_to contain_class('icingaweb2::module::reporting::service') }
      end

      context "#{os} with db_type 'pgsql', import_schema 'true'" do
        let(:params) do
          { db_type: 'pgsql',
            import_schema: true }
        end

        it { is_expected.to contain_exec('import icingaweb2::module::reporting schema') }
      end
    end
  end
end
