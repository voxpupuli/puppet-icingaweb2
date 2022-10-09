require 'spec_helper'

describe('icingaweb2::resource::database', type: :define) do
  let(:title) { 'myresource' }
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

      context "#{os} with type db" do
        let(:params) do
          {
            host: 'localhost',
            port: 3306,
            type: 'mysql',
            database: 'foo',
            username: 'bar',
            password: 'secret',
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('resource-myresource')
            .with_target('/etc/icingaweb2/resources.ini')
            .with_settings('type' => 'db', 'db' => 'mysql', 'host' => 'localhost', 'port' => '3306', 'dbname' => 'foo', 'username' => 'bar', 'password' => 'secret')
        }
      end

    end
  end
end
