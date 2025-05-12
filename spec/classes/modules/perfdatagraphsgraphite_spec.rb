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
        let(:params) { { git_revision: 'v0.1.1' } }

        it {
          is_expected.to contain_icingaweb2__module('perfdatagraphsgraphite')
            .with_install_method('git')
            .with_git_revision('v0.1.1')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-perfdatagraphsgraphite')
            .with_section_name('graphite')
            .with_target('/etc/icingaweb2/modules/perfdatagraphsgraphite/config.ini')
            .with_settings('api_url' => 'http://127.0.0.1:8542', 'api_tls_insecure' => false)
        }
      end

      context "#{os} with all parameters set" do
        let(:params) do
          {
            git_revision: 'v0.1.1',
            api_url: 'https://graphite.foo.bar',
            api_username: 'foobar',
            api_password: 'supersecret',
            api_timeout: 5,
            api_tls_insecure: true,
            writer_host_name_template: 'host.template',
            writer_service_name_template: 'service.template',
          }
        end

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
              'api_url' => 'https://graphite.foo.bar',
              'api_username' => 'foobar',
              'api_password' => 'supersecret',
              'api_timeout' => 5,
              'api_tls_insecure' => true,
              'writer_host_name_template' => 'host.template',
              'writer_service_name_template' => 'service.template'
            )
        }
      end
    end
  end
end
