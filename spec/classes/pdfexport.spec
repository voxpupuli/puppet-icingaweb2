require 'spec_helper'

describe('icingaweb2::module::pdfexport', type: :class) do
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

      context "#{os} with git_revision 'v1.1.0'" do
        let(:params) { { git_revision: 'v1.1.0' } }

        it {
          is_expected.to contain_icingaweb2__module('pdfexport')
            .with_install_method('git')
            .with_git_revision('v1.1.0')
        }
      end

      context "#{os} with ensure = latest" do
        let(:params) do
          {
            ensure: 'latest',
          }
        end

        it {
          is_expected.to contain_icingaweb2__module('pdfexport')
            .with_ensure('latest')
        }
      end
    end
  end
end
