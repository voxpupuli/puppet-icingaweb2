require 'spec_helper'

describe('icingaweb2::config::resource', :type => :define) do
  let(:title) { 'myresource' }
  let(:pre_condition) { [
      "class { 'icingaweb2': }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with type db" do
      let(:params) { {
          :type => 'db',
          :host => 'localhost',
          :port => '3306',
          :db_type => 'mysql',
          :db_name => 'foo',
          :db_username => 'bar',
          :db_password => 'secret' } }

      it { is_expected.to contain_file('/etc/icingaweb2/resources.ini') }

      it { is_expected.to contain_ini_setting('present /etc/icingaweb2/resources.ini [myresource] type')
                              .with_path('/etc/icingaweb2/resources.ini')
                              .with_setting('type')
                              .with_value('db') }

      it { is_expected.to contain_ini_setting('present /etc/icingaweb2/resources.ini [myresource] host')
                              .with_path('/etc/icingaweb2/resources.ini')
                              .with_setting('host')
                              .with_value('localhost') }

      it { is_expected.to contain_ini_setting('present /etc/icingaweb2/resources.ini [myresource] port')
                              .with_path('/etc/icingaweb2/resources.ini')
                              .with_setting('port')
                              .with_value('3306') }

      it { is_expected.to contain_ini_setting('present /etc/icingaweb2/resources.ini [myresource] db')
                              .with_path('/etc/icingaweb2/resources.ini')
                              .with_setting('db')
                              .with_value('mysql') }

      it { is_expected.to contain_ini_setting('present /etc/icingaweb2/resources.ini [myresource] dbname')
                              .with_path('/etc/icingaweb2/resources.ini')
                              .with_setting('dbname')
                              .with_value('foo') }

      it { is_expected.to contain_ini_setting('present /etc/icingaweb2/resources.ini [myresource] username')
                              .with_path('/etc/icingaweb2/resources.ini')
                              .with_setting('username')
                              .with_value('bar') }

      it { is_expected.to contain_ini_setting('present /etc/icingaweb2/resources.ini [myresource] password')
                              .with_path('/etc/icingaweb2/resources.ini')
                              .with_setting('password')
                              .with_value('secret') }
    end

    context "#{os} with type ldap" do
      let(:params) { {
          :type => 'ldap',
          :host => 'localhost',
          :port => '389',
          :ldap_root_dn => 'cn=foo,dc=bar',
          :ldap_bind_dn => 'cn=root,dc=bar',
          :ldap_bind_pw => 'secret' } }

      it { is_expected.to contain_file('/etc/icingaweb2/resources.ini') }

      it { is_expected.to contain_ini_setting('present /etc/icingaweb2/resources.ini [myresource] type')
                              .with_path('/etc/icingaweb2/resources.ini')
                              .with_setting('type')
                              .with_value('ldap') }

      it { is_expected.to contain_ini_setting('present /etc/icingaweb2/resources.ini [myresource] hostname')
                              .with_path('/etc/icingaweb2/resources.ini')
                              .with_setting('hostname')
                              .with_value('localhost') }

      it { is_expected.to contain_ini_setting('present /etc/icingaweb2/resources.ini [myresource] port')
                              .with_path('/etc/icingaweb2/resources.ini')
                              .with_setting('port')
                              .with_value('389') }

      it { is_expected.to contain_ini_setting('present /etc/icingaweb2/resources.ini [myresource] root_dn')
                              .with_path('/etc/icingaweb2/resources.ini')
                              .with_setting('root_dn')
                              .with_value('cn=foo,dc=bar') }

      it { is_expected.to contain_ini_setting('present /etc/icingaweb2/resources.ini [myresource] bind_dn')
                              .with_path('/etc/icingaweb2/resources.ini')
                              .with_setting('bind_dn')
                              .with_value('cn=root,dc=bar') }

      it { is_expected.to contain_ini_setting('present /etc/icingaweb2/resources.ini [myresource] bind_pw')
                              .with_path('/etc/icingaweb2/resources.ini')
                              .with_setting('bind_pw')
                              .with_value('secret') }

    end

    context "#{os} with invalid type" do
      let(:params) { {
          :type => 'foobar',
          :host => 'localhost',
          :port => '3306' } }

      it { is_expected.to raise_error(Puppet::Error, /foobar isn't supported/) }
    end
  end
end