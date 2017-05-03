require 'spec_helper'

describe 'icingaweb2::mod::director', :type => :class do
  let (:facts) { debian_facts }

  let :pre_condition do
    'include ::icingaweb2'
  end

  describe 'without parameters' do
    it { should create_class('icingaweb2::mod::director') }
    it { should contain_file('/etc/icingaweb2/modules/director') }
    it { should contain_file('/etc/icingaweb2/enabledModules/director') }
    it { should contain_file('/usr/share/icingaweb2/modules/director') }
    it { should contain_file('/etc/icingaweb2/modules/director/config.ini') }
    it { should contain_file('/etc/icingaweb2/modules/director/kickstart.ini') }
    it { should contain_vcsrepo('director') }
    it { should contain_exec('Icinga Director DB migration').with_command(
        "icingacli director migration run"
    )
    }
    it { should contain_exec('Icinga Director Kickstart').with_command(
        "icingacli director kickstart run"
    )
    }
  end

  describe 'with parameter: git_repo' do
    let (:params) {
      {
          :install_method => 'git',
          :git_repo => '_git_repo_'
      }
    }

    it {
      should contain_vcsrepo('director').with(
          'path' => /modules\/director$/
      )
    }
  end

  describe 'with parameter: git_revision' do
    let (:params) {
      {
          :install_method => 'git',
          :git_revision => '_git_revision_'
      }
    }

    it {
      should contain_vcsrepo('director').with(
          'revision' => /_git_revision_/
      )
    }
  end

  describe 'with parameter: install_method' do
    let (:params) {
      {
          :install_method => 'git'
      }
    }

    it { should contain_vcsrepo('director') }
  end

  describe 'with parameter: pkg_deps' do
    let (:params) {
      {
          :pkg_deps => '_pkg_deps_'
      }
    }

    it { should contain_package('_pkg_deps_').with(
        'ensure' => 'present'
    )
    }
  end

  describe 'with parameter: pkg_ensure' do
    let (:params) {
      {
          :pkg_deps => '_pkg_deps_',
          :pkg_ensure => '_pkg_ensure_'
      }
    }

    it { should contain_package('_pkg_deps_').with(
        'ensure' => '_pkg_ensure_'
    )
    }
  end

  describe 'with parameter: web_root' do
    let (:params) {
      {
          :web_root => '/web/root'
      }
    }

    it { should contain_file('/web/root/modules/director') }
  end

  describe 'with parameter: db_resource' do
    let (:params) { {:db_resource => '"_db_resource_"'} }

    it {
      should contain_icingaweb2__config__resource_database('"_db_resource_"')
    }
    it {
      should contain_ini_setting('director db resource').with(
          'section' => /db/,
          'setting' => /resource/,
          'value' => /_db_resource_/
      )
    }
  end

  describe 'with parameter: director_db' do
    let (:params) { {:director_db => '"_director_db_"'} }

    it {
      should contain_icingaweb2__config__resource_database('director_db').with(
          'resource_db' => /_director_db_/
      )
    }
  end

  describe 'with parameter: director_db_host' do
    let (:params) { {:director_db_host => '"_director_db_host_"'} }

    it {
      should contain_icingaweb2__config__resource_database('director_db').with(
          'resource_host' => /_director_db_host_/
      )
    }
  end

  describe 'with parameter: director_db_name' do
    let (:params) { {:director_db_name => '"_director_db_name_"'} }

    it {
      should contain_icingaweb2__config__resource_database('director_db').with(
          'resource_dbname' => /_director_db_name_/
      )
    }
  end

  describe 'with parameter: director_db_pass' do
    let (:params) { {:director_db_pass => '"_director_db_pass_"'} }

    it {
      should contain_icingaweb2__config__resource_database('director_db').with(
          'resource_password' => /_director_db_pass_/
      )
    }
  end

  describe 'with parameter: director_db_port' do
    let (:params) { {:director_db_port => '"_director_db_port_"'} }

    it {
      should contain_icingaweb2__config__resource_database('director_db').with(
          'resource_port' => /_director_db_port_/
      )
    }
  end

  describe 'with parameter: director_db_user' do
    let (:params) { {:director_db_user => '"_director_db_user_"'} }

    it {
      should contain_icingaweb2__config__resource_database('director_db').with(
          'resource_username' => /_director_db_user_/
      )
    }
  end

  describe 'with parameter: endpoint_name' do
    let (:params) {
      {
          :endpoint_name => '_endpoint_name_'
      }
    }

    it { should contain_ini_setting('director kickstart endpoint name').with(
        'section' => /config/,
        'setting' => /endpoint/,
        'value' => /_endpoint_name_/
    )
    }
  end

  describe 'with parameter: endpoint_host' do
    let (:params) {
      {
          :endpoint_host => '_endpoint_host_'
      }
    }

    it { should contain_ini_setting('director kickstart endpoint host').with(
        'section' => /config/,
        'setting' => /host/,
        'value' => /_endpoint_host_/
    )
    }
  end

  describe 'with parameter: endpoint_port' do
    let (:params) {
      {
          :endpoint_port => '_endpoint_port_'
      }
    }

    it { should contain_ini_setting('director kickstart endpoint port').with(
        'section' => /config/,
        'setting' => /port/,
        'value' => /_endpoint_port_/
    )
    }
  end

  describe 'with parameter: endpoint_username' do
    let (:params) {
      {
          :endpoint_username => '_endpoint_username_'
      }
    }

    it { should contain_ini_setting('director kickstart endpoint username').with(
        'section' => /config/,
        'setting' => /username/,
        'value' => /_endpoint_username_/
    )
    }
  end

  describe 'with parameter: endpoint_password' do
    let (:params) {
      {
          :endpoint_password => '_endpoint_password_'
      }
    }

    it { should contain_ini_setting('director kickstart endpoint password').with(
        'section' => /config/,
        'setting' => /password/,
        'value' => /_endpoint_password_/
    )
    }
  end
end
