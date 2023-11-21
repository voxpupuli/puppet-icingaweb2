require 'spec_helper'

describe('icingaweb2::module::icingadb', type: :class) do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with some settings, local MySQL and Redis" do
        let(:pre_condition) do
          [
            "class { 'icingaweb2': db_type => 'mysql' }",
          ]
        end

        let(:params) do
          {
            settings: {
              'foo' => 'bar',
            },
            db_type: 'mysql',
            db_password: 'secret',
          }
        end

        it {
          is_expected.to contain_icingaweb2__module('icingadb')
            .with_ensure('present')
            .with_install_method('package')
            .with_settings({})
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-icingadb-config')
            .with_section_name('icingadb')
            .with_target('/etc/icingaweb2/modules/icingadb/config.ini')
            .with_settings({ 'resource' => 'icingadb' })
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-icingadb-redis')
            .with_section_name('redis')
            .with_target('/etc/icingaweb2/modules/icingadb/config.ini')
            .with_settings({})
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-icingadb-redis1')
            .with_section_name('redis1')
            .with_target('/etc/icingaweb2/modules/icingadb/redis.ini')
            .with_settings({ 'host' => 'localhost' })
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-icingadb-redis2')
            .with_section_name('redis2')
            .with_target('/etc/icingaweb2/modules/icingadb/redis.ini')
            .with_settings({})
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-icingadb-settings')
            .with_section_name('settings')
            .with_target('/etc/icingaweb2/modules/icingadb/config.ini')
            .with_settings({ 'foo' => 'bar' })
        }

        it {
          is_expected.to contain_icingaweb2__resource__database('icingadb').with(
            {
              'type' => 'mysql',
              'host' => 'localhost',
              'database' => 'icingadb',
              'username' => 'icingadb',
              'password' => 'secret',
              'charset'  => nil,
              'use_tls'  => nil,
            },
          )
        }
      end

      context "#{os} with local PostgreSQL, db_resource_name 'foobaz'  and two Redis with TLS, different ports and own passwords" do
        let(:pre_condition) do
          [
            "class { 'icingaweb2': db_type => 'pgsql', tls_cacert_file => '/foo/bar' }",
          ]
        end

        let(:params) do
          {
            db_type: 'pgsql',
            db_resource_name: 'foobaz',
            redis_use_tls: true,
            redis_primary_host: 'redis1.icinga.com',
            redis_primary_port: 4711,
            redis_primary_password: 'secret1',
            redis_secondary_host: 'redis2.icinga.com',
            redis_secondary_port: 4712,
            redis_secondary_password: 'secret2',
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-icingadb-config')
            .with_section_name('icingadb')
            .with_target('/etc/icingaweb2/modules/icingadb/config.ini')
            .with_settings({ 'resource' => 'foobaz' })
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-icingadb-redis')
            .with_section_name('redis')
            .with_target('/etc/icingaweb2/modules/icingadb/config.ini')
            .with_settings({ 'tls' => true, 'ca' => '/foo/bar' })
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-icingadb-redis1')
            .with_section_name('redis1')
            .with_target('/etc/icingaweb2/modules/icingadb/redis.ini')
            .with_settings({ 'host' => 'redis1.icinga.com', 'port' => 4711, 'password' => 'secret1' })
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-icingadb-redis2')
            .with_section_name('redis2')
            .with_target('/etc/icingaweb2/modules/icingadb/redis.ini')
            .with_settings({ 'host' => 'redis2.icinga.com', 'port' => 4712, 'password' => 'secret2' })
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-icingadb-settings')
            .with_section_name('settings')
            .with_target('/etc/icingaweb2/modules/icingadb/config.ini')
            .with_settings({})
        }

        it {
          is_expected.to contain_icingaweb2__resource__database('foobaz').with(
            {
              'type' => 'pgsql',
              'host' => 'localhost',
              'database' => 'icingadb',
              'username' => 'icingadb',
              'charset'  => nil,
              'use_tls'  => nil,
            },
          )
        }
      end

      context "#{os} with db_use_tls 'true', db_port '4711', db_charset 'foo'" do
        let(:pre_condition) do
          [
            "class { 'icingaweb2': db_type => 'mysql', tls_cacert_file => '/foo/bar', tls_capath => '/foo/bar', tls_noverify => true, tls_cipher => 'cipher' }",
          ]
        end

        let(:params) do
          {
            db_type: 'mysql',
            db_port: 4711,
            db_charset: 'foo',
            db_use_tls: true,
          }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('icingadb').with(
            {
              'type' => 'mysql',
              'host' => 'localhost',
              'port' => 4711,
              'database' => 'icingadb',
              'username' => 'icingadb',
              'charset' => 'foo',
              'use_tls' => true,
              'tls_cacert' => '/foo/bar',
              'tls_capath' => '/foo/bar',
              'tls_noverify' => true,
              'tls_cipher' => 'cipher',
            },
          )
        }
      end

      context "#{os} with db_use_tls 'true', db_tls_cacert 'cacert', db_tls_capath '/foo/bar', db_tls_noverify 'true', db_tls_cipher 'cipher'" do
        let(:pre_condition) do
          [
            "class { 'icingaweb2': db_type => 'pgsql' }",
          ]
        end

        let(:params) do
          {
            db_type: 'pgsql',
            db_use_tls: true,
            db_tls_cacert_file: '/foo/bar',
            db_tls_capath: '/foo/bar',
            db_tls_noverify: true,
            db_tls_cipher: 'cipher',
          }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('icingadb').with(
            {
              'type' => 'pgsql',
              'host' => 'localhost',
              'database' => 'icingadb',
              'username' => 'icingadb',
              'use_tls' => true,
              'tls_cacert' => '/foo/bar',
              'tls_capath' => '/foo/bar',
              'tls_noverify' => true,
              'tls_cipher' => 'cipher',
            },
          )
        }
      end
    end
  end
end
