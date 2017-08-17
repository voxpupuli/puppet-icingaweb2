require 'spec_helper'

describe('icingaweb2::module::doc', :type => :class) do
  let(:pre_condition) { [
      "class { 'icingaweb2': }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "with ensure present" do
      let(:params) { { :ensure => 'present', } }

      it { is_expected.to contain_icingaweb2__module('doc')
        .with_install_method('none')
        .with_module_dir('/usr/share/icingaweb2/modules/doc')
        .with_ensure('present')
                       }
    end

    context "with ensure absent" do
      let(:params) { { :ensure => 'absent', } }

      it { is_expected.to contain_icingaweb2__module('doc')
        .with_install_method('none')
        .with_module_dir('/usr/share/icingaweb2/modules/doc')
        .with_ensure('absent')
                       }
    end

    context "with ensure foobar" do
      let(:params) { { :ensure => 'foobar' } }

      it { is_expected.to raise_error(Puppet::Error, /foobar isn't supported/) }
    end

  end
end
