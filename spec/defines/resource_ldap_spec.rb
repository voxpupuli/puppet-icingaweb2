require 'spec_helper'

describe('icingaweb2::resource::ldap', type: :define) do
  let(:title) { 'myresource' }
  let(:pre_condition) do
    [
      "class { 'icingaweb2': db_type => 'mysql', db_password => 'secret' }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with type ldap" do
        let(:params) do
          {
            host: 'localhost',
            port: 389,
            root_dn: 'cn=foo,dc=bar',
            bind_dn: 'cn=root,dc=bar',
            bind_pw: 'secret',
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
            host: 'localhost',
            port: 389,
            root_dn: 'cn=foo,dc=bar',
            bind_dn: 'cn=root,dc=bar',
            bind_pw: 'secret',
            timeout: 60,
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
    end
  end
end
