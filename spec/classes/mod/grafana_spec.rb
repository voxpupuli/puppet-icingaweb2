require 'spec_helper'

describe 'icingaweb2::mod::grafana', :type => :class do
  let (:facts) {debian_facts}

  let :pre_condition do
    'include ::icingaweb2'
  end

  describe 'without parameters' do
    let (:params) {
      {
          :host => '_host_',
          :datasource => 'graphite',
          :defaultdashboard => '_defaultdashboard_'
      }
    }
    it {should create_class('icingaweb2::mod::grafana')}
    it {should contain_file('/etc/icingaweb2/modules/grafana')}
    it {should contain_file('/etc/icingaweb2/enabledModules/grafana')}
    it {should contain_file('/usr/share/icingaweb2/modules/grafana')}
    it {
      should contain_ini_setting('host').with(
          'section' => /grafana/,
          'setting' => /host/,
          'value' => /_host_/
      )
    }
    it {
      should contain_ini_setting('datasource').with(
          'section' => /grafana/,
          'setting' => /datasource/,
          'value' => /graphite/
      )
    }
    it {
      should contain_ini_setting('defaultdashboard').with(
          'section' => /grafana/,
          'setting' => /defaultdashboard/,
          'value' => /_defaultdashboard_/
      )
    }
    it {should contain_vcsrepo('grafana')}
  end

  describe 'with parameter: git_repo' do
    let (:params) {
      {
          :install_method => 'git',
          :git_repo       => '_git_repo_',
          :host => '_host_',
          :datasource => 'graphite',
          :defaultdashboard => '_defaultdashboard_',
      }
    }

    it {
      should contain_vcsrepo('grafana').with(
          'path' => /modules\/grafana/
      )
    }
  end

  describe 'with parameter: git_revision' do
    let (:params) {
      {
          :install_method => 'git',
          :git_revision   => '_git_revision_',
          :host => '_host_',
          :datasource => 'graphite',
          :defaultdashboard => '_defaultdashboard_',
      }
    }

    it {
      should contain_vcsrepo('grafana').with(
          'revision' => /_git_revision_/
      )
    }
  end

  describe 'with parameter: username' do
    let (:params) {
      {
          :username => '_username_',
          :host => '_host_',
          :datasource => 'graphite',
          :defaultdashboard => '_defaultdashboard_',
      }
    }

    it {should contain_ini_setting('username').with(
        'section' => /grafana/,
        'setting' => /username/,
        'value' => /_username_/
    )}
  end

  describe 'with parameter: password' do
    let (:params) {
      {
          :password => '_password_',
          :host => '_host_',
          :datasource => 'graphite',
          :defaultdashboard => '_defaultdashboard_',
      }
    }

    it {should contain_ini_setting('password').with(
        'section' => /grafana/,
        'setting' => /password/,
        'value' => /_password_/
    )}
  end

  describe 'with parameter: protocol' do
    let (:params) {
      {
          :protocol => '_protocol_',
          :host => '_host_',
          :datasource => 'graphite',
          :defaultdashboard => '_defaultdashboard_',
      }
    }

    it {should contain_ini_setting('protocol').with(
        'section' => /grafana/,
        'setting' => /protocol/,
        'value' => /_protocol_/
    )}
  end

  describe 'with parameter: graph_height' do
    let (:params) {
      {
          :graph_height => '_graph_height_',
          :host => '_host_',
          :datasource => 'graphite',
          :defaultdashboard => '_defaultdashboard_',
      }
    }

    it {should contain_ini_setting('graph_height').with(
        'section' => /grafana/,
        'setting' => /graph_height/,
        'value' => /_graph_height_/
    )}
  end

  describe 'with parameter: graph_width' do
    let (:params) {
      {
          :graph_width => '_graph_width_',
          :host => '_host_',
          :datasource => 'graphite',
          :defaultdashboard => '_defaultdashboard_',
      }
    }

    it {should contain_ini_setting('graph_width').with(
        'section' => /grafana/,
        'setting' => /graph_width/,
        'value' => /_graph_width_/
    )}
  end

  describe 'with parameter: timerange' do
    let (:params) {
      {
          :timerange => '_timerange_',
          :host => '_host_',
          :datasource => 'graphite',
          :defaultdashboard => '_defaultdashboard_',
      }
    }

    it {should contain_ini_setting('timerange').with(
        'section' => /grafana/,
        'setting' => /timerange/,
        'value' => /_timerange_/
    )}
  end

  describe 'with parameter: enable_link' do
    let (:params) {
      {
          :enable_link => '_enable_link_',
          :host => '_host_',
          :datasource => 'graphite',
          :defaultdashboard => '_defaultdashboard_',
      }
    }

    it {should contain_ini_setting('enable_link').with(
        'section' => /grafana/,
        'setting' => /enableLink/,
        'value' => /_enable_link_/
    )}
  end

  describe 'with parameter: defaultdashboardstore' do
    let (:params) {
      {
          :defaultdashboardstore => '_defaultdashboardstore_',
          :host => '_host_',
          :datasource => 'graphite',
          :defaultdashboard => '_defaultdashboard_',
      }
    }

    it {should contain_ini_setting('defaultdashboardstore').with(
        'section' => /grafana/,
        'setting' => /defaultdashboardstore/,
        'value' => /_defaultdashboardstore_/
    )}
  end

  describe 'with parameter: accessmode' do
    let (:params) {
      {
          :accessmode => '_accessmode_',
          :host => '_host_',
          :datasource => 'graphite',
          :defaultdashboard => '_defaultdashboard_',
      }
    }

    it {should contain_ini_setting('accessmode').with(
        'section' => /grafana/,
        'setting' => /accessmode/,
        'value' => /_accessmode_/
    )}
  end

  describe 'with parameter: timeout' do
    let (:params) {
      {
          :timeout => '_timeout_',
          :host => '_host_',
          :datasource => 'graphite',
          :defaultdashboard => '_defaultdashboard_',
      }
    }

    it {should contain_ini_setting('timeout').with(
        'section' => /grafana/,
        'setting' => /timeout/,
        'value' => /_timeout_/
    )}
  end

  describe 'with parameter: directrefresh' do
    let (:params) {
      {
          :directrefresh => '_directrefresh_',
          :host => '_host_',
          :datasource => 'graphite',
          :defaultdashboard => '_defaultdashboard_',
      }
    }

    it {should contain_ini_setting('directrefresh').with(
        'section' => /grafana/,
        'setting' => /directrefresh/,
        'value' => /_directrefresh_/
    )}
  end

end
