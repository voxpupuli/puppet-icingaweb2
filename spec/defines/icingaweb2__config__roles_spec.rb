require 'spec_helper'

describe 'icingaweb2::config::roles' do

  context 'with no set values' do

    let(:title) { 'admins' }

    it 'should absent all settings' do

      should contain_ini_setting('icingaweb2 roles admins users').with_ensure('absent')
      should contain_ini_setting('icingaweb2 roles admins groups').with_ensure('absent')
      should contain_ini_setting('icingaweb2 roles admins permissions').with_ensure('absent')
      should contain_ini_setting('icingaweb2 roles admins host filter').with_ensure('absent')
      should contain_ini_setting('icingaweb2 roles admins service filter').with_ensure('absent')
    end

  end

  context 'with values' do

    let(:title) { 'Test' }

    let(:params) do
      {
        :role_name           => 'test',
        :role_users          => 'icingaadmin,icingauser',
        :role_groups         => 'icingaadmins',
        :role_permissions    => '*',
        :role_host_filter    => '*',
        :role_service_filter => '*',
      }
    end

    it 'should add settings' do

      should contain_ini_setting('icingaweb2 roles Test users').with({
        :ensure  => :present,
        :section => 'test',
        :setting => 'users',
        :value   => '"icingaadmin,icingauser"',
      })
      should contain_ini_setting('icingaweb2 roles Test groups').with({
        :ensure  => :present,
        :section => 'test',
        :setting => 'groups',
        :value   => '"icingaadmins"',
      })
      should contain_ini_setting('icingaweb2 roles Test permissions').with({
        :ensure  => :present,
        :section => 'test',
        :setting => 'permissions',
        :value   => '"*"',
      })
      should contain_ini_setting('icingaweb2 roles Test host filter').with({
        :ensure  => :present,
        :section => 'test',
        :setting => 'monitoring/hosts/filter',
        :value   => '"*"',
      })
      should contain_ini_setting('icingaweb2 roles Test service filter').with({
        :ensure  => :present,
        :section => 'test',
        :setting => 'monitoring/services/filter',
        :value   => '"*"',
      })
    end

  end
end