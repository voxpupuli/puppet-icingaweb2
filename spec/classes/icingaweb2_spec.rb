require 'spec_helper'

describe 'icingaweb2', :type => :class do
  let (:pre_condition) { '$concat_basedir = "/tmp"' }
  let (:facts) { debian_facts }
  let (:params) {
    {
      :config_dir => '/etc/icingaweb2'
    }
  }

  let :pre_condition do
    'User <| |>'
  end

  describe 'it compiles? shipt it!', :all do
    it { should compile }
    it { should compile.with_all_deps }
  end

  describe 'without parameters' do
    it { should create_class('icingaweb2') }
    it { should contain_class('icingaweb2::config') }
    it { should contain_class('icingaweb2::install') }
    it { should contain_class('icingaweb2::params') }
    it { should contain_class('icingaweb2::preinstall') }

    it { should contain_file('/etc/icingaweb2') }
    it { should contain_file('/etc/icingaweb2/authentication.ini') }
    it { should contain_file('/etc/icingaweb2/config.ini') }
    it { should contain_file('/etc/icingaweb2/enabledModules') }
    it { should contain_file('/etc/icingaweb2/modules') }
    it { should contain_file('/etc/icingaweb2/resources.ini') }
    it { should contain_file('/etc/icingaweb2/roles.ini') }
    it { should contain_file('/usr/share/icingaweb2') }

    it { should contain_group('icingaweb2') }
    it { should contain_user('icingaweb2') }
  end

  describe 'with parameter: admin_permissions' do
    let (:params) {
      {
        :admin_permissions => '_admin_permissions_'
      }
    }

    it { should contain_file('/etc/icingaweb2/roles.ini').with(
        'content' => /permissions.*_admin_permissions_/
      )
    }
  end

  describe 'with parameter: admin_users' do
    let (:params) {
      {
        :admin_users => '_admin_users_'
      }
    }

    it { should contain_file('/etc/icingaweb2/roles.ini').with(
        'content' => /users.*_admin_users_/
      )
    }
  end

  describe 'with parameter: auth_backend' do
    let (:params) {
      {
        :auth_backend => '_auth_backend_'
      }
    }

    it { should contain_file('/etc/icingaweb2/authentication.ini').with(
        'content' => /backend.*_auth_backend_/
      )
    }
  end

  describe 'with parameter: auth_resource' do
    let (:params) {
      {
        :auth_resource => '_auth_resource_'
      }
    }

    it { should contain_file('/etc/icingaweb2/authentication.ini').with(
        'content' => /resource.*_auth_resource_/
      )
    }
  end

  describe 'with parameter: config_dir' do
    let (:params) { { :config_dir => '/test/etc/icingaweb2' } }

    it { should contain_file('/test/etc/icingaweb2') }
    it { should contain_file('/test/etc/icingaweb2/authentication.ini') }
    it { should contain_file('/test/etc/icingaweb2/config.ini') }
    it { should contain_file('/test/etc/icingaweb2/enabledModules') }
    it { should contain_file('/test/etc/icingaweb2/modules') }
    it { should contain_file('/test/etc/icingaweb2/resources.ini') }
    it { should contain_file('/test/etc/icingaweb2/roles.ini') }
  end

  describe 'with parameter: config_file_mode' do
    let (:params) { { :config_file_mode => '0124' } }

    it {
      should contain_file('/etc/icingaweb2/config.ini').with(
        'mode' => '0124'
      )
    }
  end

  describe 'with parameter: config_group' do
    let (:params) { { :config_group => '_GROUP_' } }

    it {
      should contain_file('/etc/icingaweb2/config.ini').with(
        'group' => '_GROUP_'
      )
    }
  end

  describe 'with parameter: config_user' do
    let (:params) { { :config_user => '_USER_' } }

    it {
      should contain_file('/etc/icingaweb2/config.ini').with(
        'owner' => '_USER_'
      )
    }
  end

  describe 'with parameter: install_method' do
    context 'install_method => git' do
      let (:params) { { :install_method => 'git' } }

      it { should contain_vcsrepo('icingaweb2') }
    end

    context 'install_method => package' do
      let (:params) {
        {
          :install_method => 'package',
          :pkg_ensure => 'purged',
          :pkg_list => [ '_PKG_' ]
        }
      }

      it {
        should contain_package('_PKG_').with(
          'ensure' => 'purged'
        )
      }
    end
  end

  describe 'with parameter: log_application' do
    let (:params) {
      {
        :log_application => '_log_application_'
      }
    }

    it { should contain_file('/etc/icingaweb2/config.ini').with(
        'content' => /application.*_log_application_/
      )
    }
  end

  describe 'with parameter: log_level' do
    let (:params) {
      {
        :log_level => '_log_level_'
      }
    }

    it { should contain_file('/etc/icingaweb2/config.ini').with(
        'content' => /level.*_log_level_/
      )
    }
  end

  describe 'with parameter: log_method' do
    let (:params) {
      {
        :log_method => '_log_method_'
      }
    }

    it { should contain_file('/etc/icingaweb2/config.ini').with(
        'content' => /log.*_log_method_/
      )
    }
  end

  describe 'with parameter: log_resource' do
    let (:params) {
      {
        :log_resource => '_log_resource_'
      }
    }

    it { should contain_file('/etc/icingaweb2/config.ini').with(
        'content' => /resource.*_log_resource_/
      )
    }
  end

  describe 'with parameter: log_store' do
    let (:params) {
      {
        :log_store => '_log_store_'
      }
    }

    it { should contain_file('/etc/icingaweb2/config.ini').with(
        'content' => /store.*_log_store_/
      )
    }
  end

  describe 'with parameter: ido_db' do
    let (:params) { { :ido_db => '"_ido_db_"' } }

    it {
      should contain_file('/etc/icingaweb2/resources.ini').with(
        'content' => /^db.*"_ido_db_"/
      )
    }
  end

  describe 'with parameter: ido_db_host' do
    let (:params) { { :ido_db_host => '"_ido_db_host_"' } }

    it {
      should contain_file('/etc/icingaweb2/resources.ini').with(
        'content' => /^host.*"_ido_db_host_"/
      )
    }
  end

  describe 'with parameter: ido_db_name' do
    let (:params) { { :ido_db_name => '"_ido_db_name_"' } }

    it {
      should contain_file('/etc/icingaweb2/resources.ini').with(
        'content' => /^dbname.*"_ido_db_name_"/
      )
    }
  end

  describe 'with parameter: ido_db_pass' do
    let (:params) { { :ido_db_pass => '"_ido_db_pass_"' } }

    it {
      should contain_file('/etc/icingaweb2/resources.ini').with(
        'content' => /^password.*"_ido_db_pass_"/
      )
    }
  end

  describe 'with parameter: ido_db_port' do
    let (:params) { { :ido_db_port => '"_ido_db_port_"' } }

    it {
      should contain_file('/etc/icingaweb2/resources.ini').with(
        'content' => /^port.*"_ido_db_port_"/
      )
    }
  end

  describe 'with parameter: ido_db_user' do
    let (:params) { { :ido_db_user => '"_ido_db_user_"' } }

    it {
      should contain_file('/etc/icingaweb2/resources.ini').with(
        'content' => /^username.*"_ido_db_user_"/
      )
    }
  end

  describe 'with parameter: ido_type' do
    let (:params) { { :ido_type => '"_ido_type_"' } }

    it {
      should contain_file('/etc/icingaweb2/resources.ini').with(
        'content' => /^type.*"_ido_type_"/
      )
    }
  end

  describe 'with parameter: web_type' do
    let (:params) { { :web_type => '"_web_type_"' } }

    it {
      should contain_file('/etc/icingaweb2/resources.ini').with(
        'content' => /^type.*"_web_type_"/
      )
    }
  end

  describe 'with parameter: web_db_host' do
    let (:params) { { :web_db_host => '"_web_db_host_"' } }

    it {
      should contain_file('/etc/icingaweb2/resources.ini').with(
        'content' => /^host.*"_web_db_host_"/
      )
    }
  end

  describe 'with parameter: web_db_name' do
    let (:params) { { :web_db_name => '"_web_db_name_"' } }

    it {
      should contain_file('/etc/icingaweb2/resources.ini').with(
        'content' => /^dbname.*"_web_db_name_"/
      )
    }
  end

  describe 'with parameter: web_db_pass' do
    let (:params) { { :web_db_pass => '"_web_db_pass_"' } }

    it {
      should contain_file('/etc/icingaweb2/resources.ini').with(
        'content' => /^password.*"_web_db_pass_"/
      )
    }
  end

  describe 'with parameter: web_db_port' do
    let (:params) { { :web_db_port => '"_web_db_port_"' } }

    it {
      should contain_file('/etc/icingaweb2/resources.ini').with(
        'content' => /^port.*"_web_db_port_"/
      )
    }
  end

  describe 'with parameter: web_db_prefix' do
    let (:params) { { :web_db_prefix => '"_web_db_prefix_"' } }

    it {
      should contain_file('/etc/icingaweb2/resources.ini').with(
        'content' => /^prefix.*"_web_db_prefix_"/
      )
    }
  end

  describe 'with parameter: web_db_user' do
    let (:params) { { :web_db_user => '"_web_db_user_"' } }

    it {
      should contain_file('/etc/icingaweb2/resources.ini').with(
        'content' => /^username.*"_web_db_user_"/
      )
    }
  end

  describe 'with parameter: web_type' do
    let (:params) { { :web_type => '"_web_type_"' } }

    it {
      should contain_file('/etc/icingaweb2/resources.ini').with(
        'content' => /^type.*"_web_type_"/
      )
    }
  end

  describe 'with parameter: manage_apache_vhost' do
    let (:pre_condition) { '$concat_basedir = "/tmp"' }
    context 'manage_apache_vhost => true' do
      let (:params) { { :manage_apache_vhost => true } }

      it { should contain_apache__custom_config('icingaweb2') }
    end

    context 'manage_apache_vhost => false' do
      let (:params) { { :manage_apache_vhost => false } }

      it { should_not contain_apache__custom_config('icingaweb2') }
    end
  end

  describe 'with parameter: manage_repo => true' do
    context 'with parameter: manage_repo => true' do
      let (:params) { { :manage_repo => true } }

      pending
    end

    context 'with parameter: manage_repo => false' do
      let (:params) { { :manage_repo => false } }

      pending
    end
  end

  describe 'with parameter: pkg_ensure' do
    let (:params) {
      {
        :install_method => 'package',
        :pkg_ensure => 'purged',
        :pkg_list => [ '_PKG_' ]
      }
    }

    it {
      should contain_package('_PKG_').with(
        'ensure' => 'purged'
      )
    }
  end

  describe 'with parameter: pkg_list' do
    let (:params) {
      {
        :install_method => 'package',
        :pkg_list => [ '_PKG_' ]
      }
    }

    it {
      should contain_package('_PKG_')
    }
  end

  describe 'with parameter: web_root' do
    let (:pre_condition) { '$concat_basedir = "/tmp"' }
    context 'default' do
      let (:params) { { :web_root => '/web/root' } }

      it { should contain_file('/web/root').with(
          'ensure' => 'directory'
        )
      }
    end

    context 'manage_apache_vhost => true' do
      let (:params) {
        {
          :manage_apache_vhost => true,
          :web_root => '/web/root'
        }
      }

      it { should contain_file('/web/root').with(
          'ensure' => 'directory'
        )
      }

      it { should contain_apache__custom_config('icingaweb2').with(
          'content' => /Alias.*\/web\/root/,
          'content' => /<Directory.*\/web\/root/
        )
      }
    end
  end
end

