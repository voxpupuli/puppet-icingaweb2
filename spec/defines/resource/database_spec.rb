require 'spec_helper'

describe('icingaweb2::resource::database', type: :define) do
  let(:title) { 'myresource_db' }
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
        let(:params) do
          {
            type: 'oracle',
            database: 'foo',
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('resource-myresource_db')
            .with_section_name('myresource_db')
            .with_target('/etc/icingaweb2/resources.ini')
            .with_settings(
              'type' => 'db',
              'db' => 'oracle',
              'dbname' => 'foo',
            )
        }
      end

      context "#{os} with valid parameters" do
        let(:params) do
          {
            type: 'mysql',
            resource_name: 'newresource_db',
            host: 'host.icinga.com',
            port: 3306,
            database: 'foo',
            username: 'bar',
            password: 'secret',
            charset: 'utf8',
            use_tls: true,
            tls_noverify: true,
            tls_key: '/foo/certs/bar.key',
            tls_cert: '/foo/certs/bar.crt',
            tls_cacert: '/foo/certs/ca.crt',
            tls_capath: '/foo/bar',
            tls_cipher: 'foobar',
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('resource-newresource_db')
            .with_section_name('newresource_db')
            .with_target('/etc/icingaweb2/resources.ini')
            .with_settings(
              'type' => 'db',
              'db' => 'mysql',
              'host' => 'host.icinga.com',
              'port' => 3306,
              'dbname' => 'foo',
              'username' => 'bar',
              'password' => 'secret',
              'charset' => 'utf8',
              'use_ssl' => true,
              'ssl_do_not_verify_server_cert' => true,
              'ssl_cert' => '/foo/certs/bar.crt',
              'ssl_key' => '/foo/certs/bar.key',
              'ssl_ca' => '/foo/certs/ca.crt',
              'ssl_capath' => '/foo/bar',
              'ssl_cipher' => 'foobar',
            )
        }
      end
    end
  end
end
