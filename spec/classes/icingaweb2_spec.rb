require 'spec_helper'

describe 'icingaweb2', :type => :class do
  let (:facts) { debian_facts }
  let (:params) {
    {
      :config_dir => '/etc/icingaweb2'
    }
  }

  let :pre_condition do
    'User <| |>'
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
    it { should contain_file('/usr/share/icingaweb2/modules') }

    it { should contain_group('icingaweb2') }
    it { should contain_user('icingaweb2') }
  end

  describe 'with parameter: admin_permissions' do
    let (:params) {
      {
        :admin_permissions => '_admin_permissions_'
      }
    }

    it {
      should contain_icingaweb2__config__roles('Admins').with(
        'role_permissions' => /_admin_permissions_/
      )
    }
  end

  describe 'with parameter: admin_users' do
    let (:params) {
      {
        :admin_users => '_admin_users_'
      }
    }

    it {
      should contain_icingaweb2__config__roles('Admins').with(
        'role_users' => /_admin_users_/
      )
    }
  end

  describe 'with parameter: auth_backend' do
    context 'auth_backend => db' do
      let (:params) { { :auth_backend => 'db' } }
      it {
        should contain_icingaweb2__config__authentication_database('Local Database Authentication').with('auth_section' => 'icingaweb2')
      }
    end
    context 'auth_backend => external' do
      let (:params) { { :auth_backend => 'external' } }
      it {
        should contain_icingaweb2__config__authentication_external('External Authentication').with('auth_section' => 'icingaweb2')
      }
    end
    context 'auth_backend => ldap' do
      let (:params) { { :auth_backend => 'ldap' } }
      it {
        should contain_icingaweb2__config__authentication_ldap('LDAP Authentication').with('auth_section' => 'icingaweb2')
      }
    end
  end

  describe 'with parameter: auth_resource' do
    let (:params) {
      {
        :auth_resource => '_auth_resource_'
      }
    }

    it {
      should contain_icingaweb2__config__authentication_database('Local Database Authentication').with(
        'auth_resource' => /_auth_resource_/
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

    it { should contain_ini_setting('icingaweb2 config logging application').with(
        'section' => /logging/,
        'value'   => /_log_application_/
      )
    }
  end

  describe 'with parameter: log_level' do
    let (:params) {
      {
        :log_level => '_log_level_'
      }
    }

    it { should contain_ini_setting('icingaweb2 config logging level').with(
        'section' => /logging/,
        'value'   => /_log_level_/
      )
    }
  end

  describe 'with parameter: log_method' do
    let (:params) {
      {
        :log_method => '_log_method_'
      }
    }

    it { should contain_ini_setting('icingaweb2 config logging method').with(
        'section' => /logging/,
        'value'   => /_log_method_/
      )
    }
  end

  describe 'with parameter: log_resource' do
    let (:params) {
      {
        :log_resource => '_log_resource_'
      }
    }

    it { should contain_ini_setting('icingaweb2 config preferences resource').with(
        'section' => /preferences/,
        'value'   => /_log_resource_/
      )
    }
  end

  describe 'with parameter: log_store' do
    let (:params) {
      {
        :log_store => '_log_store_'
      }
    }

    it { should contain_ini_setting('icingaweb2 config preferences store').with(
        'section' => /preferences/,
        'value'   => /_log_store_/
      )
    }
  end

  describe 'with parameter: ido_db' do
    let (:params) { { :ido_db => '"_ido_db_"' } }

    it {
      should contain_icingaweb2__config__resource_database('icinga_ido').with(
        'resource_db' => /_ido_db_/
      )
    }
  end

  describe 'with parameter: ido_db_host' do
    let (:params) { { :ido_db_host => '"_ido_db_host_"' } }

    it {
      should contain_icingaweb2__config__resource_database('icinga_ido').with(
        'resource_host' => /_ido_db_host_/
      )
    }
  end

  describe 'with parameter: ido_db_name' do
    let (:params) { { :ido_db_name => '"_ido_db_name_"' } }

    it {
      should contain_icingaweb2__config__resource_database('icinga_ido').with(
        'resource_dbname' => /_ido_db_name_/
      )
    }
  end

  describe 'with parameter: ido_db_pass' do
    let (:params) { { :ido_db_pass => '"_ido_db_pass_"' } }

    it {
      should contain_icingaweb2__config__resource_database('icinga_ido').with(
        'resource_password' => /_ido_db_pass_/
      )
    }
  end

  describe 'with parameter: ido_db_port' do
    let (:params) { { :ido_db_port => '"_ido_db_port_"' } }

    it {
      should contain_icingaweb2__config__resource_database('icinga_ido').with(
        'resource_port' => /_ido_db_port_/
      )
    }
  end

  describe 'with parameter: ido_db_user' do
    let (:params) { { :ido_db_user => '"_ido_db_user_"' } }

    it {
      should contain_icingaweb2__config__resource_database('icinga_ido').with(
        'resource_username' => /_ido_db_user_/
      )
    }
  end

  describe 'with parameter: ido_type' do
    pending
  end

  describe 'with parameter: initialize => true' do
    context 'Distro: CentOS' do
      context 'install_method => git' do
        let (:params) { { :initialize => true, :install_method => 'git' } }
        let (:facts) { centos_facts }

        it { should contain_class('icingaweb2::initialize') }
        it { should contain_exec('create db scheme').with_command("mysql --defaults-file='/root/.my.cnf' icingaweb2 < /usr/share/icingaweb2/etc/schema/mysql.schema.sql") }
      end
      context 'install_method => package' do
        let (:params) { { :initialize => true, :install_method => 'package' } }
        let (:facts) { centos_facts }

        it { should contain_class('icingaweb2::initialize') }
        it { should contain_exec('create db scheme').with_command("mysql --defaults-file='/root/.my.cnf' icingaweb2 < /usr/share/doc/icingaweb2/schema/mysql.schema.sql") }
      end
    end
  end

  describe 'with parameter: web_db_host' do
    let (:params) { { :web_db_host => '"_web_db_host_"' } }

    it {
      should contain_icingaweb2__config__resource_database('icingaweb_db').with(
        'resource_host' => /_web_db_host_/
      )
    }
  end

  describe 'with parameter: web_db_name' do
    let (:params) { { :web_db_name => '"_web_db_name_"' } }

    it {
      should contain_icingaweb2__config__resource_database('icingaweb_db').with(
        'resource_dbname' => /_web_db_name_/
      )
    }
  end

  describe 'with parameter: web_db_pass' do
    let (:params) { { :web_db_pass => '"_web_db_pass_"' } }

    it {
      should contain_icingaweb2__config__resource_database('icingaweb_db').with(
        'resource_password' => /_web_db_pass_/
      )
    }
  end

  describe 'with parameter: web_db_port' do
    let (:params) { { :web_db_port => '"_web_db_port_"' } }

    it {
      should contain_icingaweb2__config__resource_database('icingaweb_db').with(
        'resource_port' => /_web_db_port_/
      )
    }
  end

  describe 'with parameter: web_db_prefix' do
    pending
  end

  describe 'with parameter: web_db_user' do
    let (:params) { { :web_db_user => '"_web_db_user_"' } }

    it {
      should contain_icingaweb2__config__resource_database('icingaweb_db').with(
        'resource_username' => /_web_db_user_/
      )
    }
  end

  describe 'with parameter: web_type' do
    pending
  end

  describe 'with parameter: manage_apache_vhost' do
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
      context 'Distro: CentOS' do
        let (:params) { { :manage_repo => true } }
        let (:facts) { centos_facts }

        it { should_not contain_icingaweb2__preinstall__redhat('icingaweb2') }
      end
    end

    context 'with parameter: manage_repo => false' do
      context 'Distro: Debian' do
        let (:params) { { :manage_repo => false } }
          let (:facts) { debian_facts }

        pending
      end
    end
  end

  describe 'icingaweb2::manage_user' do
    context 'with manage_user => true' do
      let (:params) { { :manage_user => true } }

      it { should contain_user('icingaweb2') }
      it { should contain_group('icingaweb2') }
    end

    context 'with manage_user => false' do
      let (:params) { { :manage_user => false } }

      it { should_not contain_user('icingaweb2') }
      it { should_not contain_group('icingaweb2') }
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

  describe 'with parameter: pkg_repo_release_key' do
    context 'Distro: CentOS' do
      let (:facts) { centos_facts }
      let (:params) {
        {
          :manage_repo => true,
          :install_method => 'package',
          :pkg_repo_release_key => '_PKG_REPO_RELEASE_KEY_',
          :pkg_repo_version => 'release'
        }
      }

      it {
        should contain_icingaweb2__preinstall__redhat('icingaweb2').with(
          'pkg_repo_version' => /release/
        )
      }

      it {
        should contain_yumrepo('ICINGA-release').with(
          'gpgkey' => /_PKG_REPO_RELEASE_KEY_/
        )
      }
    end

    context 'Distro: Debian' do
      let (:facts) { debian_facts }

      pending
    end
  end

  describe 'with parameter: pkg_repo_release_metadata_expire' do
    context 'Distro: CentOS' do
      let (:facts) { centos_facts }
      let (:params) {
        {
          :manage_repo => true,
          :install_method => 'package',
          :pkg_repo_release_metadata_expire => '_PKG_REPO_RELEASE_METADATA_EXPIRE_',
          :pkg_repo_version => 'release'
        }
      }

      it {
        should contain_icingaweb2__preinstall__redhat('icingaweb2').with(
          'pkg_repo_version' => /release/
        )
      }

      it {
        should contain_yumrepo('ICINGA-release').with(
          'metadata_expire' => /_PKG_REPO_RELEASE_METADATA_EXPIRE_/
        )
      }
    end

    context 'Distro: Debian' do
      let (:facts) { debian_facts }

      pending
    end
  end

  describe 'with parameter: pkg_repo_release_url' do
    context 'Distro: CentOS' do
      let (:facts) { centos_facts }
      let (:params) {
        {
          :manage_repo => true,
          :install_method => 'package',
          :pkg_repo_release_url => '_PKG_REPO_RELEASE_URL_',
          :pkg_repo_version => 'release'
        }
      }

      it {
        should contain_icingaweb2__preinstall__redhat('icingaweb2').with(
          'pkg_repo_version' => /release/
        )
      }

      it {
        should contain_yumrepo('ICINGA-release').with(
          'baseurl' => /_PKG_REPO_RELEASE_URL_/
        )
      }
    end

    context 'Distro: Debian' do
      let (:facts) { debian_facts }

      pending
    end
  end

  describe 'with parameter: pkg_repo_snapshot_key' do
    context 'Distro: CentOS' do
      let (:facts) { centos_facts }
      let (:params) {
        {
          :manage_repo => true,
          :install_method => 'package',
          :pkg_repo_snapshot_key => '_PKG_REPO_SNAPSHOT_KEY_',
          :pkg_repo_version => 'snapshot'
        }
      }

      it {
        should contain_icingaweb2__preinstall__redhat('icingaweb2').with(
          'pkg_repo_version' => /snapshot/
        )
      }

      it {
        should contain_yumrepo('ICINGA-snapshot').with(
          'gpgkey' => /_PKG_REPO_SNAPSHOT_KEY_/
        )
      }
    end

    context 'Distro: Debian' do
      let (:facts) { debian_facts }

      pending
    end
  end

  describe 'with parameter: pkg_repo_snapshot_metadata_expire' do
    context 'Distro: CentOS' do
      let (:facts) { centos_facts }
      let (:params) {
        {
          :manage_repo => true,
          :install_method => 'package',
          :pkg_repo_snapshot_metadata_expire => '_PKG_REPO_SNAPSHOT_METADATA_EXPIRE_',
          :pkg_repo_version => 'snapshot'
        }
      }

      it {
        should contain_icingaweb2__preinstall__redhat('icingaweb2').with(
          'pkg_repo_version' => /snapshot/
        )
      }

      it {
        should contain_yumrepo('ICINGA-snapshot').with(
          'metadata_expire' => /_PKG_REPO_SNAPSHOT_METADATA_EXPIRE_/
        )
      }
    end

    context 'Distro: Debian' do
      let (:facts) { debian_facts }

    end
  end

  describe 'with parameter: pkg_repo_snapshot_url' do
    context 'Distro: CentOS' do
      let (:facts) { centos_facts }
      let (:params) {
        {
          :manage_repo => true,
          :install_method => 'package',
          :pkg_repo_snapshot_url => '_PKG_REPO_SNAPSHOT_URL_',
          :pkg_repo_version => 'snapshot'
        }
      }

      it {
        should contain_icingaweb2__preinstall__redhat('icingaweb2').with(
          'pkg_repo_version' => /snapshot/
        )
      }

      it {
        should contain_yumrepo('ICINGA-snapshot').with(
          'baseurl' => /_PKG_REPO_SNAPSHOT_URL_/
        )
      }
    end

    context 'Distro: Debian' do
      let (:facts) { debian_facts }

      pending
    end
  end

  describe 'with parameter: web_root' do
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

