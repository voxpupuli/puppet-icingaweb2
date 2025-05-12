require 'spec_helper'

describe('icingaweb2::module::perfdatagraphs', type: :class) do
  let(:pre_condition) do
    [
      "class { 'icingaweb2': db_type => 'mysql', db_password => 'secret' }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with git_revision 'v0.1.1'" do
        let(:params) { { git_revision: 'v0.1.1', default_backend: 'Graphite' } }

        it {
          is_expected.to contain_icingaweb2__module('perfdatagraphs')
            .with_install_method('git')
            .with_git_revision('v0.1.1')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-perfdatagraphs')
            .with_section_name('perfdatagraphs')
            .with_target('/etc/icingaweb2/modules/perfdatagraphs/config.ini')
            .with_settings('default_backend' => 'Graphite', 'default_timerange' => 'PT12H')
        }
      end

      context "#{os} with all parameters set" do
        let(:params) do
          {
            git_revision: 'v0.1.1',
            default_backend: 'Graphite',
            default_timerange: 'PT6H30M',
            cache_lifetime: 3,
          }
        end

        it {
          is_expected.to contain_icingaweb2__module('perfdatagraphs')
            .with_install_method('git')
            .with_git_revision('v0.1.1')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('icingaweb2-module-perfdatagraphs')
            .with_section_name('perfdatagraphs')
            .with_target('/etc/icingaweb2/modules/perfdatagraphs/config.ini')
            .with_settings('default_backend' => 'Graphite', 'default_timerange' => 'PT6H30M', 'cache_lifetime' => 3)
        }
      end
    end
  end
end
