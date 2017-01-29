require 'spec_helper'

describe 'icingaweb2::mod::deployment' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :pre_condition do
        "class { '::icingaweb2': install_method => 'package', }"
      end

      describe 'without parameters' do
        it { should_not compile }
      end

      describe 'with parameter: auth_token' do
        let :params do
          {
            :auth_token => '_auth_token_'
          }
        end

        it { should create_class('icingaweb2::mod::deployment') }

        it { should contain_vcsrepo('deployment').with_path('/usr/share/icingaweb2/modules/deployment') }

        it { should contain_file('/etc/icingaweb2/modules/deployment').with_ensure('directory') }
        it do
          should contain_ini_setting('deployment auth token').with(
            'section' => /auth/,
            'setting' => /token/,
            'value'   => /_auth_token_/
          )
        end
      end

      describe 'with parameter: git_repo' do
        let :params do
          {
            auth_token:     'token',
            install_method: 'git',
            git_repo:       '_git_repo_'
          }
        end

        it {
          should contain_vcsrepo('deployment').with(
            'path' => /modules\/deployment$/
          )
        }
      end

      describe 'with parameter: git_revision' do
        let :params do
          {
            auth_token:     'token',
            install_method: 'git',
            git_revision:   '_git_revision_'
          }
        end

        it {
          should contain_vcsrepo('deployment').with(
            'revision' => /_git_revision_/
          )
        }
      end

      describe 'with parameter: install_method' do
        describe 'install_method => git' do
          let :params do
            {
              auth_token:     'token',
              install_method: 'git'
            }
          end

          it { should contain_vcsrepo('deployment') }
        end
      end

      describe 'with parameter: pkg_deps' do
        describe 'install_method => git' do
          let :params do
            {
              auth_token: 'token',
              pkg_deps:   '_pkg_deps_'
            }
          end

          it do
            should contain_package('_pkg_deps_').with(
              'ensure' => 'present'
            )
          end
        end
      end

      describe 'with parameter: pkg_ensure' do
        describe 'install_method => git' do
          let :params do
            {
              auth_token: 'token',
              pkg_deps:   '_pkg_deps_',
              pkg_ensure: '_pkg_ensure_'
            }
          end

          it do
            should contain_package('_pkg_deps_').with(
              'ensure' => '_pkg_ensure_'
            )
          end
        end
      end

      describe 'with parameter: web_root' do
        let :params do
          {
            auth_token: 'token',
            web_root:   '/web/root'
          }
        end

        it { should contain_vcsrepo('deployment').with_path('/web/root/modules/deployment') }
      end
    end
  end
end
