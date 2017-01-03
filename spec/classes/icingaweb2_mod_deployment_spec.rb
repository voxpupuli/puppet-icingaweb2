require 'spec_helper'

describe 'icingaweb2::mod::deployment', :type => :class do
  let (:facts) { debian_facts }

  let :pre_condition do
    'include ::icingaweb2'
  end

  describe 'without parameters' do
    it { should_not compile }
  end

  describe 'with parameter: auth_token' do
    let (:params) {
      {
        :auth_token => '_auth_token_'
      }
    }

    it { should create_class('icingaweb2::mod::deployment') }
    it { should contain_file('/usr/share/icingaweb2/modules/deployment') }
    it { should contain_vcsrepo('deployment') }

    it { should contain_ini_setting('deployment auth token').with(
        'section' => /auth/,
        'setting' => /token/,
        'value'   => /_auth_token_/
      )
    }
  end

  describe 'with parameter: git_repo' do
    let (:params) {
      {
        :auth_token     => 'token',
        :install_method => 'git',
        :git_repo       => '_git_repo_'
      }
    }

    it {
      should contain_vcsrepo('deployment').with(
        'path' => /modules\/deployment$/
      )
    }
  end

  describe 'with parameter: git_revision' do
    let (:params) {
      {
        :auth_token     => 'token',
        :install_method => 'git',
        :git_revision   => '_git_revision_'
      }
    }

    it {
      should contain_vcsrepo('deployment').with(
        'revision' => /_git_revision_/
      )
    }
  end

  describe 'with parameter: install_method' do
    describe 'install_method => git' do
      let (:params) {
        {
          :auth_token     => 'token',
          :install_method => 'git'
        }
      }

      it { should contain_vcsrepo('deployment') }
    end

    describe 'install_method => package' do
      pending
    end
  end

  describe 'with parameter: pkg_deps' do
    describe 'install_method => git' do
      let (:params) {
        {
          :auth_token     => 'token',
          :pkg_deps => '_pkg_deps_'
        }
      }

      it { should contain_package('_pkg_deps_').with(
          'ensure' => 'present'
        )
      }
    end

    describe 'install_method => package' do
      pending
    end
  end

  describe 'with parameter: pkg_ensure' do
    describe 'install_method => git' do
      let (:params) {
        {
          :auth_token     => 'token',
          :pkg_deps   => '_pkg_deps_',
          :pkg_ensure => '_pkg_ensure_'
        }
      }

      it { should contain_package('_pkg_deps_').with(
          'ensure' => '_pkg_ensure_'
        )
      }
    end

    describe 'install_method => package' do
      pending
    end
  end

  describe 'with parameter: web_root' do
    let (:params) {
      {
        :auth_token => 'token',
        :web_root   => '/web/root'
      }
    }

    it { should contain_file('/web/root/modules/deployment') }
  end
end
