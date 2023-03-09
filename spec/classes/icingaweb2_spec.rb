require 'spec_helper'

describe('icingaweb2', type: :class) do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with defaults' do
        it { is_expected.to compile }
        it { is_expected.to contain_class('icingaweb2::config') }
        it { is_expected.to contain_class('icingaweb2::install') }
        it { is_expected.to contain_package('icingaweb2').with('ensure' => 'installed') }
      end

      context 'with manage_package => false' do
        let(:params) do
          { manage_package: false }
        end

        it { is_expected.not_to contain_package('icinga2').with('ensure' => 'installed') }
      end

      context 'with additional resources, user and group backend' do
        let(:params) do
          {
            resources: {
              foo: { type: 'ldap' },
              baz: { type: 'pgsql', host: 'localhost', database: 'baz', port: 5432 },
            },
            user_backends: {
              bar: { backend: 'ldap', resource: 'foo' },
            },
            group_backends: {
              bar: { backend: 'ldap', resource: 'foo' },
            },
          }
        end

        it { is_expected.to contain_icingaweb2__resource__ldap('foo') }
        it { is_expected.to contain_icingaweb2__resource__database('baz').with('type' => 'pgsql') }
        it { is_expected.to contain_icingaweb2__config__authmethod('bar').with('resource' => 'foo') }
        it { is_expected.to contain_icingaweb2__config__groupbackend('bar').with('resource' => 'foo') }
      end
    end
  end
end
