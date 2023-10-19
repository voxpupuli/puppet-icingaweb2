require 'spec_helper'

describe('icingaweb2::module::vspheredb::service', type: :class) do
  let(:pre_condition) do
    [
      "class { 'icingaweb2': db_type => 'mysql' }",
      "class { 'icingaweb2::module::vspheredb': db_type => 'mysql' }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with defaults" do
        it do
          is_expected.to contain_user('icingavspheredb')
            .with(
              'ensure' => 'present',
              'gid'    => 'icingaweb2',
              'shell'  => '/bin/false',
            ).that_comes_before(['Systemd::Unit_file[icinga-vspheredb.service]', 'Systemd::Tmpfile[icinga-vspheredb.conf]'])
        end
        it do
          is_expected.to contain_systemd__tmpfile('icinga-vspheredb.conf').with(
            content: %r{/run/icinga-vspheredb},
          ).that_comes_before('Systemd::Unit_file[icinga-vspheredb.service]')
        end
        it do
          is_expected.to contain_systemd__unit_file('icinga-vspheredb.service').with(
            content: %r{[Unit]},
          ).that_notifies('Service[icinga-vspheredb]')
        end
        it do
          is_expected.to contain_service('icinga-vspheredb')
            .with(
              'ensure' => 'running',
              'enable' => true,
            )
        end
      end
    end
  end
end
