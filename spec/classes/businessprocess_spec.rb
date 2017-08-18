require 'spec_helper'

describe('icingaweb2::module::businessprocess', :type => :class) do
  let(:pre_condition) { [
      "class { 'icingaweb2': }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "with git_revision 'v2.1.0'" do
      let(:params) { { :git_revision => 'v2.1.0', } }

      it { is_expected.to contain_icingaweb2__module('businessprocess')
        .with_install_method('git')
        .with_git_revision('v2.1.0')
      }
    end
  end
end