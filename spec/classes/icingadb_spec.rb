require 'spec_helper'

describe('icingaweb2::module::icingadb', type: :class) do
  let(:pre_condition) do
    [
      "class { 'icingaweb2': db_type => 'mysql' }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with local MySQL and Redis" do
        let(:params) do
          {
            db_type: 'mysql',
          }
        end

        it {
          is_expected.to contain_icingaweb2__module('icingadb').with(
            {
              'ensure'         => 'present',
              'install_method' => 'package',
              'settings'       => {
                'icingaweb2-module-icingadb-config' => {
                  'section_name' => 'icingadb',
                  'target'       => '/etc/icingaweb2/modules/icingadb/config.ini',
                  'settings'     => {
                    'resource' => 'icingaweb2-module-icingadb',
                  },
                },
                'icingaweb2-module-icingadb-redis' => {
                  'section_name' => 'redis',
                  'target'       => '/etc/icingaweb2/modules/icingadb/config.ini',
                  'settings'     => {},
                },
                'icingaweb2-module-icingadb-redis1' => {
                  'section_name' => 'redis1',
                  'target'       => '/etc/icingaweb2/modules/icingadb/redis.ini',
                  'settings'     => {
                    'host' => 'localhost',
                  },
                },
                'icingaweb2-module-icingadb-redis2' => {
                  'section_name' => 'redis2',
                  'target'       => '/etc/icingaweb2/modules/icingadb/redis.ini',
                  'settings'     => {},
                },
              },
            },
          )
        }

        it {
          is_expected.to contain_icingaweb2__resource__database('icingaweb2-module-icingadb').with(
            {
              'type' => 'mysql',
              'host' => 'localhost',
              'port' => 3306,
              'database' => 'icingadb',
              'username' => 'icingadb',
              'charset'  => nil,
              'use_tls'  => nil,
            },
          )
        }
      end

      context "#{os} with local PostgreSQL and Redis" do
        let(:params) do
          {
            db_type: 'pgsql',
          }
        end

        it {
          is_expected.to contain_icingaweb2__module('icingadb').with(
            {
              'ensure'         => 'present',
              'install_method' => 'package',
              'settings'       => {
                'icingaweb2-module-icingadb-config' => {
                  'section_name' => 'icingadb',
                  'target'       => '/etc/icingaweb2/modules/icingadb/config.ini',
                  'settings'     => {
                    'resource' => 'icingaweb2-module-icingadb',
                  },
                },
                'icingaweb2-module-icingadb-redis' => {
                  'section_name' => 'redis',
                  'target'       => '/etc/icingaweb2/modules/icingadb/config.ini',
                  'settings'     => {},
                },
                'icingaweb2-module-icingadb-redis1' => {
                  'section_name' => 'redis1',
                  'target'       => '/etc/icingaweb2/modules/icingadb/redis.ini',
                  'settings'     => {
                    'host' => 'localhost',
                  },
                },
                'icingaweb2-module-icingadb-redis2' => {
                  'section_name' => 'redis2',
                  'target'       => '/etc/icingaweb2/modules/icingadb/redis.ini',
                  'settings'     => {},
                },
              },
            },
          )
        }

        it {
          is_expected.to contain_icingaweb2__resource__database('icingaweb2-module-icingadb').with(
            {
              'type' => 'pgsql',
              'host' => 'localhost',
              'port' => 5432,
              'database' => 'icingadb',
              'username' => 'icingadb',
              'charset'  => nil,
              'use_tls'  => nil,
            },
          )
        }
      end
    end
  end
end
