require 'spec_helper'

describe('icingaweb2::module::perfdatagraphsinfluxdbv2', type: :class) do
  let(:pre_condition) do
    [
      "class { 'icingaweb2': db_type => 'mysql', db_password => 'secret' }",
      "class { 'icingaweb2::module::perfdatagraphs': git_revision => 'v0.1.1', default_backend => 'Graphite' }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with default connection settings" do
        let(:params) { { org: 'icinga', bucket: 'icinga2' } }

        it {
          is_expected.to contain_icingaweb2__module('perfdatagraphsinfluxdbv2')
            .with_install_method('git')
            .with_git_revision('master')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-perfdatagraphsinfluxdbv2')
            .with_section_name('influx')
            .with_target('/etc/icingaweb2/modules/perfdatagraphsinfluxdbv2/config.ini')
            .with_settings(
              'api_url' => 'http://127.0.0.1:8086',
              'api_org' => 'icinga',
              'api_bucket' => 'icinga2',
              'api_auth_method' => 'none',
              'api_auth_mtls' => false,
              'api_tls_insecure' => false,
            )
        }
      end

      context "#{os} with basic authentication" do
        let(:params) do
          {
            org: 'icinga',
            bucket: 'icinga2',
            auth_method: 'basic',
            auth_basic: {
              username: 'icinga',
              password: 'secret',
            },
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-perfdatagraphsinfluxdbv2')
            .with_settings(
              'api_url' => 'http://127.0.0.1:8086',
              'api_org' => 'icinga',
              'api_bucket' => 'icinga2',
              'api_auth_method' => 'basic',
              'api_auth_username' => 'icinga',
              'api_auth_password' => sensitive('secret'),
              'api_auth_mtls' => false,
              'api_tls_insecure' => false,
            )
        }
      end

      context "#{os} with token authentication" do
        let(:params) do
          {
            org: 'icinga',
            bucket: 'icinga2',
            auth_method: 'token',
            auth_token: {
              type: 'Token',
              value: 'secret-token',
            },
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-perfdatagraphsinfluxdbv2')
            .with_settings(
              'api_url' => 'http://127.0.0.1:8086',
              'api_org' => 'icinga',
              'api_bucket' => 'icinga2',
              'api_auth_method' => 'token',
              'api_auth_tokentype' => 'Token',
              'api_auth_tokenvalue' => sensitive('secret-token'),
              'api_auth_mtls' => false,
              'api_tls_insecure' => false,
            )
        }
      end

      context "#{os} with writer options and TLS paths" do
        let(:params) do
          {
            org: 'icinga',
            bucket: 'icinga2',
            timeout: 15,
            max_data_points: 2000,
            writer_host_name_template_tag: 'host_name',
            writer_service_name_template_tag: 'service_name',
            writer_host_template_measurement: '$host.check_command$',
            writer_service_template_measurement: '$service.check_command$',
            use_tls: true,
            tls_cert_file: '/etc/icingaweb2/client.crt',
            tls_key_file: '/etc/icingaweb2/client.key',
            tls_cacert_file: '/etc/icingaweb2/ca.crt',
            tls_insecure: true,
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-perfdatagraphsinfluxdbv2')
            .with_settings(
              'api_url' => 'http://127.0.0.1:8086',
              'api_org' => 'icinga',
              'api_bucket' => 'icinga2',
              'api_timeout' => 15,
              'api_max_data_points' => 2000,
              'writer_host_name_template_tag' => 'host_name',
              'writer_service_name_template_tag' => 'service_name',
              'writer_host_template_measurement' => '$host.check_command$',
              'writer_service_template_measurement' => '$service.check_command$',
              'api_auth_method' => 'none',
              'api_auth_mtls' => true,
              'api_auth_mtls_cert' => '/etc/icingaweb2/client.crt',
              'api_auth_mtls_key' => '/etc/icingaweb2/client.key',
              'api_auth_mtls_ca' => '/etc/icingaweb2/ca.crt',
              'api_tls_insecure' => true,
            )
        }
      end

      context "#{os} with managed TLS certificate contents" do
        let(:params) do
          {
            org: 'icinga',
            bucket: 'icinga2',
            use_tls: true,
            tls_cert: 'client certificate',
            tls_key: 'client private key',
            tls_cacert: 'client CA certificate',
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-perfdatagraphsinfluxdbv2')
            .with_settings(
              'api_url' => 'http://127.0.0.1:8086',
              'api_org' => 'icinga',
              'api_bucket' => 'icinga2',
              'api_auth_method' => 'none',
              'api_auth_mtls' => true,
              'api_auth_mtls_cert' => '/var/lib/icingaweb2/certs/perfdatagraphsinfluxdbv2/perfdatagraphsinfluxdbv2.crt',
              'api_auth_mtls_key' => '/var/lib/icingaweb2/certs/perfdatagraphsinfluxdbv2/perfdatagraphsinfluxdbv2.key',
              'api_auth_mtls_ca' => '/var/lib/icingaweb2/certs/perfdatagraphsinfluxdbv2/perfdatagraphsinfluxdbv2_ca.crt',
              'api_tls_insecure' => false,
            )
        }

        it {
          is_expected.to contain_file('/var/lib/icingaweb2/certs/perfdatagraphsinfluxdbv2/perfdatagraphsinfluxdbv2.key')
            .with_content('client private key')
            .with_mode('0440')
            .with_show_diff(false)
        }
      end
    end
  end
end
