require 'spec_helper'

describe 'icingaweb2::initialize' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with default settings' do
        let :pre_condition do
          "class { 'icingaweb2': }"
        end

        it { should_not contain_exec('icingaweb2 create db schema') }
        it { should_not contain_exec('icingaweb2 create default web user') }
      end

      context 'with initialize' do
        let :pre_condition do
          "class { 'icingaweb2': initialize => true, }"
        end

        it do
          should contain_exec('icingaweb2 create db schema')
            .without_command(/\-p/)
            .with_command(/-h localhost/)
            .with_command(/-u icingaweb2/)
            .with_command(/ icingaweb2 /)
            .with_command(/\/mysql\.schema\.sql$/)
        end
        it do
          escaped_password = Regexp.escape('\$1\$EzxLOFDr\$giVx3bGhVm4lDUAw6srGX1')
          should contain_exec('icingaweb2 create default web user')
            .without_command(/\-p/)
            .with_command(/-h localhost/)
            .with_command(/-u icingaweb2/)
            .with_command(/ icingaweb2 /)
            .with_command(/-e "INSERT INTO icingaweb_user.*'icingaadmin', 1, '#{escaped_password}'\);"/m)
        end
      end
    end
  end
end
