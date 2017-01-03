require 'spec_helper'

describe 'icingaweb2::mod::graphite', :type => :class do
  let (:facts) { debian_facts }

  let :pre_condition do
    'include ::icingaweb2'
  end

  describe 'without parameters' do
    it { should create_class('icingaweb2::mod::graphite') }
    it { should contain_file('/usr/share/icingaweb2/modules/graphite') }
    it { should contain_vcsrepo('graphite') }
  end

  describe 'with parameter: git_repo' do
    let (:params) {
      {
        :install_method => 'git',
        :git_repo       => '_git_repo_'
      }
    }

    it {
      should contain_vcsrepo('graphite').with(
        'path' => /modules\/graphite$/
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
      should contain_vcsrepo('graphite').with(
        'revision' => /_git_revision_/
      )
    }
  end

  describe 'with parameter: graphite_base_url' do
    let (:params) {
      {
        :graphite_base_url => '_graphite_base_url_'
      }
    }

    it { should contain_ini_setting('base_url').with(
        'section' => /graphite/,
        'setting' => /base_url/,
        'value'   => /_graphite_base_url_/
      )
    }
  end

  describe 'with parameter: graphite_metric_prefix' do
    let (:params) {
      {
        :graphite_metric_prefix => '_graphite_metric_prefix_'
      }
    }

    it { should contain_ini_setting('metric_prefix').with(
        'section' => /graphite/,
        'setting' => /metric_prefix/,
        'value'   => /_graphite_metric_prefix_/
      )
    }
  end


  describe 'with parameter: service_name_template' do
    let (:params) {
      {
        :service_name_template=> '_service_name_template_'
      }
    }

    it { should contain_ini_setting('service_name_template').with(
        'section' => /graphite/,
        'setting' => /service_name_template/,
        'value'   => /_service_name_template_/
      )
    }
  end


  describe 'with parameter: host_name_template' do
    let (:params) {
      {
        :host_name_template=> '_host_name_template_'
      }
    }

    it { should contain_ini_setting('host_name_template').with(
        'section' => /graphite/,
        'setting' => /host_name_template/,
        'value'   => /_host_name_template_/
      )
    }
  end

  describe 'with parameter: install_method' do
    let (:params) {
      {
        :install_method => 'git'
      }
    }

    it { should contain_vcsrepo('graphite') }
  end

  describe 'with parameter: pkg_deps' do
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

  describe 'with parameter: pkg_ensure' do
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

  describe 'with parameter: web_root' do
    let (:params) {
      {
        :web_root => '/web/root'
      }
    }

    it { should contain_file('/web/root/modules/graphite') }
  end
end
