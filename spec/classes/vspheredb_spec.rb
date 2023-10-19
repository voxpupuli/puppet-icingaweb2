require 'spec_helper'

describe('icingaweb2::module::vspheredb', type: :class) do
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

      context "#{os} with git_revision 'v1.7.1'" do
        let(:params) do
          { git_revision: 'v1.7.1',
            db_type: 'mysql',
            db_host: 'localhost',
            db_name: 'vspheredb',
            db_username: 'vspheredb',
            db_password: 'vspheredb' }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('icingaweb2-module-vspheredb')
            .with_type('mysql')
            .with_host('localhost')
            .with_port('3306')
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
          is_expected.to contain_class('icingaweb2::module::vspheredb::service')
            .with_ensure('running')
            .with_enable(true)
        }
      end

      context "#{os} with install_method 'package', manage_service 'false'" do
        let(:params) do
          { install_method: 'package',
            manage_service: false,
            db_type: 'mysql',
            db_host: 'localhost',
            db_name: 'vspheredb',
            db_username: 'vspheredb',
            db_password: 'vspheredb' }
        end

        it {
          is_expected.to contain_package('icingaweb2-module-vspheredb')
            .with_ensure('installed')
        }

        it {
          is_expected.not_to contain_class('icingaweb2::module::vspheredb::service')
        }
      end
    end
  end
end
