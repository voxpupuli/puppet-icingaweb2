require 'spec_helper'

describe('icingaweb2::inisection', :type => :define) do
  let(:title) { 'foo' }
  let(:pre_condition) { [
      "class { 'icingaweb2': }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with valid params" do
      let(:params) { {:target => '/foo/bar', :section_name => 'global', :settings =>  {'setting1' => 'value1', 'setting2' => 'value2'}  } }

      it { is_expected.to contain_file('/foo/bar') }

      it { is_expected.to contain_ini_setting('present /foo/bar [global] setting1')
        .with_path('/foo/bar')
        .with_setting('setting1')
        .with_value('value1')
      }

      it { is_expected.to contain_ini_setting('present /foo/bar [global] setting2')
        .with_path('/foo/bar')
        .with_setting('setting2')
        .with_value('value2') }
    end
  end
end
