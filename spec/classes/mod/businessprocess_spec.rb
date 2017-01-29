require 'spec_helper'

describe 'icingaweb2::mod::businessprocess', :type => :class do
  let (:facts) { debian_facts }

  let :pre_condition do
    'include ::icingaweb2'
  end

  describe 'without parameters' do
    it { should create_class('icingaweb2::mod::businessprocess') }
    it { should contain_file('/usr/share/icingaweb2/modules/businessprocess') }
    it { should contain_vcsrepo('businessprocess') }
  end

  describe 'with parameter: git_repo' do
    let (:params) {
      {
        :install_method => 'git',
        :git_repo       => '_git_repo_'
      }
    }

    it {
      should contain_vcsrepo('businessprocess').with(
        'path' => /modules\/businessprocess$/
      )
    }
  end

  describe 'with parameter: git_revision' do
    let (:params) {
      {
        :install_method => 'git',
        :git_revision   => '_git_revision_'
      }
    }

    it {
      should contain_vcsrepo('businessprocess').with(
        'revision' => /_git_revision_/
      )
    }
  end

  describe 'with parameter: install_method' do
    describe 'install_method => git' do
      let (:params) {
        {
          :install_method => 'git'
        }
      }

      it { should contain_vcsrepo('businessprocess') }
    end

    describe 'install_method => package' do
      pending
    end
  end

  describe 'with parameter: pkg_deps' do
    describe 'install_method => git' do
      let (:params) {
        {
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
        :web_root => '/web/root'
      }
    }

    it { should contain_file('/web/root/modules/businessprocess') }
  end
end
