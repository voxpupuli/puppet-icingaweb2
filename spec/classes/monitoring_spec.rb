require 'spec_helper'

describe('icingaweb2::module::monitoring', :type => :class) do
  let(:pre_condition) { [
      "class { 'icingaweb2': }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "#{os} with ido_type 'mysql'" do
      let(:params) { { :ido_type => 'mysql',
                       :ido_host => 'localhost',
                       :ido_db_name => 'icinga2',
                       :ido_db_username => 'icinga2',
                       :ido_db_password => 'icinga2',
                       :api_username => 'root',
                       :api_password => 'foobar' } }


      it { is_expected.to contain_icingaweb2__module('monitoring')
        .with_install_method('none')
        .with_module_dir('/usr/share/icingaweb2/modules/monitoring')
        .with_settings({
                           'backends'=>{
                               'target'=>'/etc/icingaweb2/modules/monitoring/backends.ini',
                               'settings'=>{
                                   'type'=>'ido',
                                   'resource'=>'icingaweb2-module-monitoring'
                               }
                           },
                           'commandtransports'=>{
                               'target'=>'/etc/icingaweb2/modules/monitoring/commandtransports.ini',
                               'settings'=>{
                                   'transport'=>'api',
                                   'host'=>'localhost',
                                   'port'=>'5665',
                                   'username'=>'root',
                                   'password'=>'foobar'
                               }
                           },
                           'config'=>{
                               'target'=>'/etc/icingaweb2/modules/monitoring/config.ini',
                               'settings'=>{
                                   'protected_customvars'=>'*pw*, *pass*, community'
                               }
                           }
                       }) }
    end

    context "#{os} with invalid ido_type" do
      let(:params) { { :ido_type => 'foobar' } }

      it { is_expected.to raise_error(Puppet::Error, /foobar isn't supported/) }
    end

  end
end
