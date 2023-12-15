require 'spec_helper'

describe('icingaweb2::resource::ldap', type: :define) do
  let(:title) { 'myresource_ldap' }
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

      context "#{os} with required parameters" do
        it {
          is_expected.to contain_icingaweb2__inisection('resource-myresource_ldap')
            .with_section_name('myresource_ldap')
            .with_target('/etc/icingaweb2/resources.ini')
            .with_settings(
              'type' => 'ldap',
              'hostname' => 'localhost',
              'encryption' => 'none',
              'timeout' => 5,
            )
        }
      end

      context "#{os} with valid parameters" do
        let(:params) do
          {
            resource_name: 'newresource_ldap',
            host: 'host.icinga.com',
            port: 3268,
            root_dn: 'dc=icinga,dc=com',
            bind_dn: 'read@icinga.com',
            bind_pw: 'secret',
            encryption: 'starttls',
            timeout: 10,
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('resource-newresource_ldap')
            .with_section_name('newresource_ldap')
            .with_target('/etc/icingaweb2/resources.ini')
            .with_settings(
              'type' => 'ldap',
              'hostname' => 'host.icinga.com',
              'port' => 3268,
              'root_dn' => 'dc=icinga,dc=com',
              'bind_dn' => 'read@icinga.com',
              'bind_pw' => 'secret',
              'encryption' => 'starttls',
              'timeout' => 10,
            )
        }
      end
    end
  end
end
