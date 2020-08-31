require 'spec_helper'

describe('icingaweb2::module::director::service', type: :class) do
  let(:pre_condition) do
    [
      "class { 'icingaweb2': }",
      "class { 'icingaweb2::module::director': }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with defaults" do
        it do
          is_expected.to contain_user('icingadirector')
            .with(
              'ensure' => 'present',
              'gid' => 'icingaweb2',
              'shell' => '/bin/false',
            ).that_comes_before('Systemd::Unit_file[icinga-director.service]')
        end
        it do
          is_expected.to contain_systemd__unit_file('icinga-director.service').with(
            content: %r{[Unit]},
          ).that_notifies('Service[icinga-director]')
        end
        it do
          is_expected.to contain_service('icinga-director')
            .with(
              'ensure' => 'running',
              'enable' => true,
            )
        end
      end
    end
  end
end
