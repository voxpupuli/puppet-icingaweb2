require 'spec_helper'

describe('icingaweb2::module::director::service', :type => :class) do
  let(:pre_condition) { [
      "class { 'icingaweb2': }",
      "class { 'icingaweb2::module::director': }",
  ] }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with defaults" do
        it { is_expected.to contain_user('icingadirector')
          .with({ 'ensure' => 'present', 'gid' => 'icingaweb2', 'shell' => '/bin/false' }).that_comes_before('Systemd::Unit_file[icinga-director.service]') }
        it { is_expected.to contain_systemd__unit_file('icinga-director.service').that_notifies('Service[icinga-director]') }
        it { is_expected.to contain_service('icinga-director')
          .with({
            'ensure' => 'running',
            'enable' => true }) }

      end
    end

  end
end

