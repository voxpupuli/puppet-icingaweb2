require 'spec_helper'

describe('icingaweb2::module::audit', type: :class) do
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

      context "#{os} with defaults" do
        it {
          is_expected.to contain_icingaweb2__module('audit').with(
            {
              'ensure'         => 'present',
              'install_method' => 'git',
              'settings'       => {
                'icingaweb2-module-audit-log' => {
                  'section_name' => 'log',
                  'target'       => '/etc/icingaweb2/modules/audit/config.ini',
                  'settings'     => {
                    'type' => 'none',
                  },
                },
                'icingaweb2-module-audit-stream' => {
                  'section_name' => 'stream',
                  'target'       => '/etc/icingaweb2/modules/audit/config.ini',
                  'settings'     => {
                    'format' => 'none',
                  },
                },
              },
            },
          )
        }
      end

      context "#{os} with file logging and json stream" do
        let(:params) do
          {
            log_type: 'file',
            log_file: '/foobar.log',
            stream_format: 'json',
            stream_file: '/foobar.json',
          }
        end

        it {
          is_expected.to contain_icingaweb2__module('audit').with(
            {
              'ensure'         => 'present',
              'install_method' => 'git',
              'settings'       => {
                'icingaweb2-module-audit-log' => {
                  'section_name' => 'log',
                  'target'       => '/etc/icingaweb2/modules/audit/config.ini',
                  'settings'     => {
                    'type' => 'file',
                    'path' => '/foobar.log',
                  },
                },
                'icingaweb2-module-audit-stream' => {
                  'section_name' => 'stream',
                  'target'       => '/etc/icingaweb2/modules/audit/config.ini',
                  'settings'     => {
                    'format' => 'json',
                    'path'   => '/foobar.json',
                  },
                },
              },
            },
          )
        }
      end
    end
  end
end
