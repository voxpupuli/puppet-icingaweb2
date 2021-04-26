require 'spec_helper'

describe('icingaweb2::module::doc', type: :class) do
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

      case facts[:osfamily]
      when 'Debian'
        let(:install_method) { 'package' }
        let(:package_name) { 'icingaweb2-module-doc' }
      else
        let(:install_method) { 'none' }
        let(:package_name) { nil }
      end

      context 'with ensure present' do
        let(:params) { { ensure: 'present' } }

        it {
          is_expected.to contain_icingaweb2__module('doc')
            .with_install_method(install_method)
            .with_package_name(package_name)
            .with_module_dir('/usr/share/icingaweb2/modules/doc')
            .with_ensure('present')
        }

        if facts[:osfamily] == 'Debian'
          it { is_expected.to contain_package('icingaweb2-module-doc').with('ensure' => 'present') }
        end
      end

      context 'with ensure absent' do
        let(:params) { { ensure: 'absent' } }

        it {
          is_expected.to contain_icingaweb2__module('doc')
            .with_install_method(install_method)
            .with_package_name(package_name)
            .with_module_dir('/usr/share/icingaweb2/modules/doc')
            .with_ensure('absent')
        }

        if facts[:osfamily] == 'Debian'
          it { is_expected.to contain_package('icingaweb2-module-doc').with('ensure' => 'absent') }
        end
      end

      context 'with ensure foobar' do
        let(:params) { { ensure: 'foobar' } }

        it { is_expected.to raise_error(Puppet::Error, %r{expects a match for Enum\['absent', 'present'\]}) }
      end
    end
  end
end
