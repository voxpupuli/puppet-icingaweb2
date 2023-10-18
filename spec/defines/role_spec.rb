require 'spec_helper'

describe('icingaweb2::config::role', type: :define) do
  let(:title) { 'myrole' }
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

      context "#{os} with users and permissions" do
        let(:params) { { users: 'bob, pete', permissions: '*' } }

        it {
          is_expected.to contain_icingaweb2__inisection('role-myrole')
            .with_target('/etc/icingaweb2/roles.ini')
            .with_settings('users' => 'bob, pete', 'permissions' => '*')
        }
      end

      context "#{os} with users, permissions, refusals and filters" do
        let(:params) do
          {
            users: 'bob, pete',
            permissions: 'module/monitoring',
            refusals: 'monitoring/commands/schedule-check',
            filters: { 'monitoring/filter/objects' => 'host_name=linux-*' }
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('role-myrole')
            .with_target('/etc/icingaweb2/roles.ini')
            .with_settings(
              'users' => 'bob, pete',
              'permissions' => 'module/monitoring',
              'refusals' => 'monitoring/commands/schedule-check',
              'monitoring/filter/objects' => 'host_name=linux-*',
            )
        }
      end
    end
  end
end
