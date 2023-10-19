require 'spec_helper'

describe('icingaweb2::module::reporting::service', type: :class) do
  let(:pre_condition) do
    [
      "class { 'icingaweb2': db_type => 'mysql' }",
      "class { 'icingaweb2::module::reporting': db_type => 'mysql', manage_service => false }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with defaults" do
        it do
          is_expected.to contain_user('icingareporting')
            .with(
              'ensure' => 'present',
              'gid' => 'icingaweb2',
              'shell' => '/bin/false',
            ).that_comes_before('Systemd::Unit_file[icinga-reporting.service]')
        end
        it do
          is_expected.to contain_systemd__unit_file('icinga-reporting.service').with(
            content: %r{[Unit]},
          ).that_notifies('Service[icinga-reporting]')
        end
        it do
          is_expected.to contain_service('icinga-reporting')
            .with(
              'ensure' => 'running',
              'enable' => true,
            )
        end
      end
    end
  end
end
