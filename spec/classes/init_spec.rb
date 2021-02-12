require 'spec_helper'

describe 'icingaweb2', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let(:conf_dir) { '/etc/icingaweb2' }

      context 'with all default parameters' do
        it { is_expected.to compile }

        it { is_expected.to contain_class('icingaweb2::config') }
        it { is_expected.to contain_class('icingaweb2::install') }

        it { is_expected.to contain_package('icingaweb2').with('ensure' => 'installed') }

        context "#{os} with manage_package => false" do
          let(:params) { { manage_package: false } }

          it { is_expected.not_to contain_package('icinga2').with('ensure' => 'installed') }
        end
      end
    end
  end
end
