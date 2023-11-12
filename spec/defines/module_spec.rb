require 'spec_helper'

describe('icingaweb2::module', type: :define) do
  let(:title) { 'mymodule' }
  let(:pre_condition) do
    [
      "class { 'icingaweb2': db_type => 'mysql', conf_user => 'foobaz' }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with install_method 'none'" do
        let(:params) do
          {
            module: 'foo',
            module_dir: '/usr/local/icingaweb2-modules/foo',
            install_method: 'none',
            settings: { 'section1' => { 'target' => '/foo/bar', 'settings' => { 'setting1' => 'value1', 'setting2' => 'value2' } } }
          }
        end

        it {
          is_expected.to contain_file('/etc/icingaweb2/enabledModules/foo')
            .with_ensure('link')
            .with_owner('foobaz')
            .with_group('icingaweb2')
        }

        it {
          is_expected.to contain_file('/etc/icingaweb2/modules/foo')
            .with_ensure('directory')
            .with_mode('2770')
            .with_owner('root')
            .with_group('icingaweb2')
        }

        it {
          is_expected.to contain_file('/var/lib/icingaweb2/foo')
            .with_ensure('directory')
            .with_mode('2770')
            .with_owner('root')
            .with_group('icingaweb2')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('section1')
            .with_target('/foo/bar')
            .with_settings('setting1' => 'value1', 'setting2' => 'value2')
        }
      end

      context "#{os} with install_method 'git'" do
        let(:params) do
          { module: 'foo',
            module_dir: '/usr/local/icingaweb2-modules/foo',
            git_repository: 'https://github.com/icinga/foo.git',
            git_revision: 'main' }
        end

        it {
          is_expected.to contain_vcsrepo('/usr/local/icingaweb2-modules/foo')
            .with_provider('git')
            .with_source('https://github.com/icinga/foo.git')
            .with_revision('main')
        }
      end

      context "#{os} with install_method 'package'" do
        let(:params) do
          { module: 'foo',
            module_dir: '/usr/local/icingaweb2-modules/foo',
            install_method: 'package',
            package_name: 'foo' }
        end

        it { is_expected.to contain_package('foo').with('ensure' => 'installed') }
      end

      context "#{os} with ensure => absent" do
        let(:params) do
          { module: 'foo',
            ensure: 'absent',
            module_dir: '/usr/local/icingaweb2-modules/foo',
            install_method: 'none' }
        end

        it { is_expected.to contain_file('/etc/icingaweb2/enabledModules/foo').with_ensure('absent') }
      end
    end
  end
end
