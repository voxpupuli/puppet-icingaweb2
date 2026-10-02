require 'spec_helper'

describe('icingaweb2::module::perfdatagraphsgraphite', type: :class) do
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

      context "#{os} with git_revision 'v0.1.1'" do
        let(:params) { { git_revision: 'v0.1.1', auth_method: 'none' } }

        it {
          is_expected.to contain_icingaweb2__module('perfdatagraphsgraphite')
            .with_install_method('git')
            .with_git_revision('v0.1.1')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-perfdatagraphsgraphite')
            .with_section_name('graphite')
            .with_target('/etc/icingaweb2/modules/perfdatagraphsgraphite/config.ini')
            .with_settings(
              'api_url' => 'http://127.0.0.1:8542',
              'api_tls_insecure' => false,
              'api_auth_method' => 'none',
              'api_auth_mtls' => false,
            )
        }
      end

      context "#{os} with auth_method = 'basic'" do
        let(:params) do
          {
            git_revision: 'v0.1.1',
            url: 'https://graphite.foo.bar',
            auth_method: 'basic',
            auth_basic: {
              username: 'foobar',
              password: 'supersecret',
            },
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-perfdatagraphsgraphite')
            .with_section_name('graphite')
            .with_target('/etc/icingaweb2/modules/perfdatagraphsgraphite/config.ini')
            .with_settings(
              'api_url' => 'https://graphite.foo.bar',
              'api_auth_method' => 'basic',
              'api_auth_username' => 'foobar',
              'api_auth_password' => sensitive('supersecret'),
              'api_auth_mtls' => false,
              'api_tls_insecure' => false,
            )
        }
      end

      context "#{os} with auth_method = 'token'" do
        let(:params) do
          {
            git_revision: 'v0.1.1',
            url: 'https://graphite.foo.bar',
            auth_method: 'token',
            auth_token: {
              type: 'Baerer',
              value: 'supersecret',
            },
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-perfdatagraphsgraphite')
            .with_section_name('graphite')
            .with_target('/etc/icingaweb2/modules/perfdatagraphsgraphite/config.ini')
            .with_settings(
              'api_url' => 'https://graphite.foo.bar',
              'api_auth_method' => 'token',
              'api_auth_tokentype' => 'Baerer',
              'api_auth_tokenvalue' => sensitive('supersecret'),
              'api_auth_mtls' => false,
              'api_tls_insecure' => false,
            )
        }
      end

      context "#{os} with all parameters set" do
        let(:params) do
          {
            git_revision: 'v0.1.1',
            url: 'https://graphite.foo.bar',
            timeout: 5,
            max_data_points: 1000,
            writer_host_name_template: 'host.template',
            writer_service_name_template: 'service.template',
            auth_method: 'none',
            use_tls: true,
            tls_cert_file: '/etc/icingaweb2/client.crt',
            tls_key_file: '/etc/icingaweb2/client.key',
            tls_cacert_file: '/etc/icingaweb2/client-ca.crt',
            tls_insecure: true,
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-perfdatagraphsgraphite')
            .with_section_name('graphite')
            .with_target('/etc/icingaweb2/modules/perfdatagraphsgraphite/config.ini')
            .with_settings(
              'api_url' => 'https://graphite.foo.bar',
              'api_timeout' => 5,
              'max_data_points' => 1000,
              'writer_host_name_template' => 'host.template',
              'writer_service_name_template' => 'service.template',
              'api_auth_method' => 'none',
              'api_auth_mtls' => true,
              'api_auth_mtls_cert' => '/etc/icingaweb2/client.crt',
              'api_auth_mtls_key' => '/etc/icingaweb2/client.key',
              'api_auth_mtls_ca' => '/etc/icingaweb2/client-ca.crt',
              'api_tls_insecure' => true,
            )
        }
      end

      context "#{os} with managed mTLS certificate contents" do
        let(:params) do
          {
            git_revision: 'v1.0.0',
            auth_method: 'none',
            use_tls: true,
            tls_cert: 'client certificate',
            tls_key: 'client private key',
            tls_cacert: 'client CA certificate',
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-perfdatagraphsgraphite')
            .with_settings(
              'api_url' => 'http://127.0.0.1:8542',
              'api_auth_method' => 'none',
              'api_auth_mtls' => true,
              'api_auth_mtls_cert' => '/var/lib/icingaweb2/certs/perfdatagraphsgraphite/perfdatagraphsgraphite.crt',
              'api_auth_mtls_key' => '/var/lib/icingaweb2/certs/perfdatagraphsgraphite/perfdatagraphsgraphite.key',
              'api_auth_mtls_ca' => '/var/lib/icingaweb2/certs/perfdatagraphsgraphite/perfdatagraphsgraphite_ca.crt',
              'api_tls_insecure' => false,
            )
        }

        it {
          is_expected.to contain_file('/var/lib/icingaweb2/certs/perfdatagraphsgraphite/perfdatagraphsgraphite.key')
            .with_content('client private key')
            .with_mode('0440')
            .with_show_diff(false)
        }

        it {
          is_expected.to contain_file('/var/lib/icingaweb2/certs/perfdatagraphsgraphite/perfdatagraphsgraphite.crt')
            .with_content('client certificate')
        }

        it {
          is_expected.to contain_file('/var/lib/icingaweb2/certs/perfdatagraphsgraphite/perfdatagraphsgraphite_ca.crt')
            .with_content('client CA certificate')
        }
      end
    end
  end
end
