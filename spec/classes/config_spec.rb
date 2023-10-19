require 'spec_helper'

describe('icingaweb2::config', type: :class) do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with default parameters, db_type => mysql' do
        let :pre_condition do
          "class { 'icingaweb2': db_type => 'mysql' }"
        end

        it { is_expected.to contain_icingaweb2__inisection('config-logging') }
        it {
          is_expected.to contain_icingaweb2__inisection('config-global')
            .with_settings('show_stacktraces' => false, 'module_path' => '/usr/share/icingaweb2/modules', 'config_resource' => 'mysql-icingaweb2')
        }
        it { is_expected.to contain_icingaweb2__inisection('config-themes') }
        it { is_expected.not_to contain_icingaweb2__inisection('config-cookie') }

        it { is_expected.to contain_icingaweb2__resource__database('mysql-icingaweb2') }
        it { is_expected.not_to contain_exec('import schema') }
        it { is_expected.not_to contain_exec('create default admin user') }
        it { is_expected.not_to contain_icingaweb2__config__role('default admin user') }
      end

      context 'with db_type => mysql, import_schema => true' do
        let :pre_condition do
          "class { 'icingaweb2': import_schema => true, db_type => 'mysql' }"
        end

        it { is_expected.to contain_icingaweb2__resource__database('mysql-icingaweb2') }
        it { is_expected.to contain_icingaweb2__config__authmethod('mysql-auth') }
        it { is_expected.to contain_icingaweb2__config__role('default admin user') }
        it { is_expected.to contain_exec('import schema') }
        it { is_expected.to contain_exec('create default admin user') }
      end

      context 'with db_type => pgsql, import_schema => true' do
        let :pre_condition do
          "class { 'icingaweb2': import_schema => true, db_type => 'pgsql' }"
        end

        it { is_expected.to contain_icingaweb2__resource__database('pgsql-icingaweb2') }
        it { is_expected.to contain_icingaweb2__config__authmethod('pgsql-auth') }
        it { is_expected.to contain_icingaweb2__config__role('default admin user') }
        it { is_expected.to contain_exec('import schema') }
        it { is_expected.to contain_exec('create default admin user') }
      end

      context 'with invalid db_type' do
        let :pre_condition do
          "class { 'icingaweb2': db_type => 'foobar' }"
        end

        it { is_expected.to raise_error(Puppet::Error, %r{expects a match for Enum\['mysql', 'pgsql'\]}) }
      end

      context 'with import_schema => true and admin_role => false' do
        let :pre_condition do
          "class { 'icingaweb2': import_schema => true, db_type => 'mysql', admin_role => false }"
        end

        it { is_expected.not_to contain_icingaweb2__config__role('default admin user') }
      end

      context 'with cookie_path => /' do
        let :pre_condition do
          "class { 'icingaweb2': cookie_path => '/', db_type => 'mysql' }"
        end

        it {
          is_expected.to contain_icingaweb2__inisection('config-cookie')
            .with_settings('path' => '/')
        }
      end
    end
  end
end
