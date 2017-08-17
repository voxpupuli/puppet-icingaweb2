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
      let(:params) { {:target => '/foo/bar', :section_name => 'test', :settings =>  {'setting1' => 'value1', 'setting2' => 'value2'}  } }

      it { is_expected.to contain_concat('/foo/bar') }

      it { is_expected.to contain_concat__fragment('foo-test-01')
        .with_target('/foo/bar')
        .with_order('01')
        .with_content(/\[test\]/)
        .with_content(/setting1=value1/)
        .with_content(/setting2=value2/)}
    end
  end
end
