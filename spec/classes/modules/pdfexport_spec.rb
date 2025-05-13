require 'spec_helper'

describe('icingaweb2::module::pdfexport', type: :class) do
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

      context "#{os} with git_revision 'v0.11.0'" do
        let(:params) { { git_revision: 'v0.11.0' } }

        it {
          is_expected.to contain_icingaweb2__module('pdfexport')
            .with_install_method('git')
            .with_git_revision('v0.11.0')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('module-pdfexport-chrome')
            .with_section_name('chrome')
            .with_target('/etc/icingaweb2/modules/pdfexport/config.ini')
        }
      end

      context "#{os} with all parameters set" do
        let(:params) do
          {
            git_revision: 'v0.11.0',
            chrome_binary: '/foo/bar',
            force_temp_storage: true,
            remote_host: 'foo.bar',
            remote_port: 1234
          }
        end

        it {
          is_expected.to contain_icingaweb2__module('pdfexport')
            .with_install_method('git')
            .with_git_revision('v0.11.0')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('module-pdfexport-chrome')
            .with_section_name('chrome')
            .with_target('/etc/icingaweb2/modules/pdfexport/config.ini')
            .with_settings('binary' => '/foo/bar', 'force_temp_storage' => true, 'host' => 'foo.bar', 'port' => 1234)
        }
      end
    end
  end
end
