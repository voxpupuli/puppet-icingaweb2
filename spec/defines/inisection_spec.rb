require 'spec_helper'

describe('icingaweb2::inisection', type: :define) do
  let(:title) { 'foo' }
  let(:pre_condition) do
    [
      "class { 'icingaweb2':
        db_type    => 'mysql',
        conf_user  => 'foo',
        conf_group => 'bar',
      }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with valid params" do
        let(:params) do
          {
            target: '/foo/bar',
            section_name: 'test', settings: { 'setting1' => 'value1', 'setting2' => 'value2' },
            order: '02',
            replace: false,
          }
        end

        it {
          is_expected.to contain_concat('/foo/bar')
            .with_owner('foo')
            .with_group('bar')
            .with_replace(false)
            .with_mode('0640')
            .with_warn(false)
        }

        it {
          is_expected.to contain_concat__fragment('foo-test-02')
            .with_target('/foo/bar')
            .with_content(%r{\[test\]\nsetting1 = \"value1\"\nsetting2 = \"value2\"\n\n})
            .with_order('02')
        }
      end
    end
  end
end
