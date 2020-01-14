require 'spec_helper'

describe('icingaweb2::module::vspheredb', :type => :class) do
  let(:pre_condition) { [
      "class { 'icingaweb2': }"
  ] }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with git_revision v1.2.3 and configure_daemon false" do
        let(:params) { { :git_revision => 'v1.2.3',
                         :db_host => 'localhost',
                         :db_name => 'vspheredb',
                         :db_username => 'vspheredb',
                         :db_password => 'vspheredb',
                         :configure_daemon => false } }

        it { is_expected.to contain_icingaweb2__config__resource('icingaweb2-module-vspheredb')
          .with_type('db')
          .with_db_type('mysql')
          .with_host('localhost')
          .with_port('3306')
          .with_db_name('vspheredb')
          .with_db_username('vspheredb')
          .with_db_password('vspheredb')
          .with_db_charset('utf8mb4')
        }

        it { is_expected.to contain_icingaweb2__module('vspheredb')
          .with_install_method('git')
          .with_git_revision('v1.2.3')
          .with_module_dir('/usr/share/icingaweb2/modules/vspheredb')
          .with_settings( {
                              'module-vspheredb-db'=>{
                                  'section_name'=>'db',
                                  'target'=>'/etc/icingaweb2/modules/vspheredb/config.ini',
                                  'settings'=>{
                                      'resource'=>'icingaweb2-module-vspheredb'}
                              },
                          }
          )}
      end

      context "#{os} with configure_daemon true" do
        let(:params) { { :git_revision => 'v1.2.3',
                         :db_host => 'localhost',
                         :db_name => 'vspheredb',
                         :db_username => 'vspheredb',
                         :db_password => 'vspheredb',
                         :configure_daemon => true } }

        it { is_expected.to contain_systemd__unit_file('icinga-vspheredb.service')
          .with_enable(true)
          .with_active(true)
          .with_source('/usr/share/icingaweb2/modules/vspheredb/contrib/systemd/icinga-vspheredb.service')
        }
      end
    end
  end
end

