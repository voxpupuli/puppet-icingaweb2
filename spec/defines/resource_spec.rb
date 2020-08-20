require 'spec_helper'

describe('icingaweb2::config::resource', type: :define) do
  let(:title) { 'myresource' }
  let(:pre_condition) do
    [
      "class { 'icingaweb2': }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with type db" do
        let(:params) do
          {
            type: 'db',
            host: 'localhost',
            port: 3306,
            db_type: 'mysql',
            db_name: 'foo',
            db_username: 'bar',
            db_password: 'secret',
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('resource-myresource')
            .with_target('/etc/icingaweb2/resources.ini')
            .with_settings('type' => 'db', 'db' => 'mysql', 'host' => 'localhost', 'port' => '3306', 'dbname' => 'foo', 'username' => 'bar', 'password' => 'secret')
        }
      end

      context "#{os} with type ldap" do
        let(:params) do
          {
            type: 'ldap',
            host: 'localhost',
            port: 389,
            ldap_root_dn: 'cn=foo,dc=bar',
            ldap_bind_dn: 'cn=root,dc=bar',
            ldap_bind_pw: 'secret',
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('resource-myresource')
            .with_target('/etc/icingaweb2/resources.ini')
            .with_settings(
              'type' => 'ldap',
              'hostname' => 'localhost',
              'port' => '389',
              'root_dn' => 'cn=foo,dc=bar',
              'bind_dn' => 'cn=root,dc=bar',
              'bind_pw' => 'secret',
              'encryption' => 'none',
              'timeout' => '5',
            )
        }
      end

      context "#{os} with type ldap and changed ldap timeout" do
        let(:params) do
          {
            type: 'ldap',
            host: 'localhost',
            port: 389,
            ldap_root_dn: 'cn=foo,dc=bar',
            ldap_bind_dn: 'cn=root,dc=bar',
            ldap_bind_pw: 'secret',
            ldap_timeout: 60,
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('resource-myresource')
            .with_target('/etc/icingaweb2/resources.ini')
            .with_settings(
              'type' => 'ldap',
              'hostname' => 'localhost',
              'port' => '389',
              'root_dn' => 'cn=foo,dc=bar',
              'bind_dn' => 'cn=root,dc=bar',
              'bind_pw' => 'secret',
              'encryption' => 'none',
              'timeout' => '60',
            )
        }
      end

      context "#{os} with invalid type" do
        let(:params) do
          {
            type: 'foobar',
            host: 'localhost',
            port: 3306,
          }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{expects a match for Enum\['db', 'ldap'\]}) }
      end
    end
  end
end
