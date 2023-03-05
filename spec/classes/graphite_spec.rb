require 'spec_helper'

describe('icingaweb2::module::graphite', type: :class) do
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

      context "#{os} with git_revision 'v0.9.0'" do
        let(:params) { { git_revision: 'v0.9.0', url: 'http://localhost' } }

        it {
          is_expected.to contain_icingaweb2__module('graphite')
            .with_install_method('git')
            .with_git_revision('v0.9.0')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('module-graphite-graphite')
            .with_section_name('graphite')
            .with_target('/etc/icingaweb2/modules/graphite/config.ini')
            .with_settings('url' => 'http://localhost')
        }
      end

      context "#{os} with all parameters set" do
        let(:params) do
          {
            git_revision: 'v0.9.0',
            url: 'http://localhost',
            insecure: false,
            user: 'foo',
            password: 'bar',
            graphite_writer_host_name_template: 'foobar',
            graphite_writer_service_name_template: 'barfoo',
            customvar_obscured_check_command: 'baz',
            default_time_range: 10,
            default_time_range_unit: 'hours',
            disable_no_graphs: true,
          }
        end

        it {
          is_expected.to contain_icingaweb2__module('graphite')
            .with_install_method('git')
            .with_git_revision('v0.9.0')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('module-graphite-graphite')
            .with_section_name('graphite')
            .with_target('/etc/icingaweb2/modules/graphite/config.ini')
            .with_settings('url' => 'http://localhost', 'insecure' => false, 'user' => 'foo', 'password' => 'bar')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('module-graphite-ui')
            .with_section_name('ui')
            .with_target('/etc/icingaweb2/modules/graphite/config.ini')
            .with_settings('default_time_range' => 10, 'default_time_range_unit' => 'hours', 'disable_no_graphs_found' => true)
        }

        it {
          is_expected.to contain_icingaweb2__inisection('module-graphite-icinga')
            .with_section_name('icinga')
            .with_target('/etc/icingaweb2/modules/graphite/config.ini')
            .with_settings('graphite_writer_host_name_template' => 'foobar',
                           'graphite_writer_service_name_template' => 'barfoo',
                           'customvar_obscured_check_command' => 'baz')
        }
      end
    end
  end
end
