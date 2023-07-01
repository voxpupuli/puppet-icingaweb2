require 'spec_helper'

describe('icingaweb2::module', type: :define) do
  let(:title) { 'mymodule' }
  let(:pre_condition) do
    [
      "class { 'icingaweb2': }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with install_method 'none'" do
        let(:params) do
          { module: 'foo',
            module_dir: '/usr/local/icingaweb2-modules/foo',
            install_method: 'none',
            settings: { 'section1' => { 'target' => '/foo/bar', 'settings' => { 'setting1' => 'value1', 'setting2' => 'value2' } } } }
        end

        it { is_expected.to contain_file('/etc/icingaweb2/enabledModules') }
        it { is_expected.to contain_file('/etc/icingaweb2/enabledModules/foo') }
        it { is_expected.to contain_file('/etc/icingaweb2/modules') }
        it { is_expected.to contain_file('/etc/icingaweb2/modules/foo') }

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
            git_revision: 'master',
            settings: { 'section1' => { 'target' => '/foo/bar', 'settings' => { 'setting1' => 'value1', 'setting2' => 'value2' } } } }
        end

        it { is_expected.to contain_file('/etc/icingaweb2/enabledModules') }
        it { is_expected.to contain_file('/etc/icingaweb2/enabledModules/foo') }
        it { is_expected.to contain_file('/etc/icingaweb2/modules') }
        it { is_expected.to contain_file('/etc/icingaweb2/modules/foo') }

        it {
          is_expected.to contain_vcsrepo('/usr/local/icingaweb2-modules/foo')
            .with_provider('git')
            .with_source('https://github.com/icinga/foo.git')
            .with_revision('master')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('section1')
            .with_target('/foo/bar')
            .with_settings('setting1' => 'value1', 'setting2' => 'value2')
        }
      end

      context "#{os} with install_method 'package'" do
        let(:params) do
          { module: 'foo',
            module_dir: '/usr/local/icingaweb2-modules/foo',
            install_method: 'package',
            package_name: 'foo',
            settings: { 'section1' => { 'target' => '/foo/bar', 'settings' => { 'setting1' => 'value1', 'setting2' => 'value2' } } } }
        end

        it { is_expected.to contain_file('/etc/icingaweb2/enabledModules') }
        it { is_expected.to contain_file('/etc/icingaweb2/enabledModules/foo') }
        it { is_expected.to contain_file('/etc/icingaweb2/modules') }
        it { is_expected.to contain_file('/etc/icingaweb2/modules/foo') }

        it { is_expected.to contain_package('foo').with('ensure' => 'installed') }

        it {
          is_expected.to contain_icingaweb2__inisection('section1')
            .with_target('/foo/bar')
            .with_settings('setting1' => 'value1', 'setting2' => 'value2')
        }
      end

      context "#{os} with invalid installation_method" do
        let(:params) do
          { module: 'foor',
            module_dir: '/usr/local/icingaweb2-modules/foo',
            install_method: 'foobar' }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{expects a match for Enum\['git', 'none', 'package'\]}) }
      end

      context "#{os} with ensure => absent" do
        let(:params) do
          { module: 'foo',
            ensure: 'absent',
            module_dir: '/usr/local/icingaweb2-modules/foo',
            install_method: 'none',
            settings: { 'section1' => { 'target' => '/foo/bar', 'settings' => { 'setting1' => 'value1', 'setting2' => 'value2' } } } }
        end

        it { is_expected.to contain_file('/etc/icingaweb2/enabledModules') }
        it { is_expected.to contain_file('/etc/icingaweb2/enabledModules/foo').with_ensure('absent') }
        it { is_expected.to contain_file('/etc/icingaweb2/modules') }
        it { is_expected.to contain_file('/etc/icingaweb2/modules/foo') }

        it {
          is_expected.to contain_icingaweb2__inisection('section1')
            .with_target('/foo/bar')
            .with_settings('setting1' => 'value1', 'setting2' => 'value2')
        }
      end

      context "#{os} with install_method => package and ensure => 1.2-3" do
        let(:params) do
          { ensure: '1.2-3',
            install_method: 'package',
            package_name: 'icingaweb2-module-mymodule', }
        end

        it { is_expected.to contain_file('/etc/icingaweb2/enabledModules/mymodule').with_ensure('link') }
        it { is_expected.to contain_file('/etc/icingaweb2/modules/mymodule').with_ensure('directory') }
        it { is_expected.to contain_package('icingaweb2-module-mymodule').with_ensure('1.2-3') }
      end

      context "#{os} with install_method => git and ensure => v1.2" do
        let(:params) do
          { ensure: 'v1.2',
            install_method: 'git',
            git_repository: 'https://github.com/icinga/mymodule.git', }
        end
        let(:modules_basedir) do
          case facts[:os]['family']
          when 'FreeBSD'
            '/usr/local/www/icingaweb2/modules'
          else
            '/usr/share/icingaweb2/modules'
          end
        end
        let(:conf_basedir) do
          case facts[:os]['family']
          when 'FreeBSD'
            '/usr/local/etc/icingaweb2'
          else
            '/etc/icingaweb2'
          end
        end

        it { is_expected.to contain_file("#{conf_basedir}/enabledModules/mymodule").with_ensure('link') }
        it { is_expected.to contain_file("#{conf_basedir}/modules/mymodule").with_ensure('directory') }
        it {
          is_expected.to contain_vcsrepo("#{modules_basedir}/mymodule")
            .with(
              ensure: 'present',
              provider: 'git',
              source: params[:git_repository],
              revision: params[:ensure],
            )
        }
      end
    end
  end
end
