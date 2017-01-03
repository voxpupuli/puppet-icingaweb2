require 'spec_helper'

describe 'icingaweb2::mod::monitoring', :type => :class do
  let (:facts) { debian_facts }

  let :pre_condition do
    'include ::icingaweb2'
  end

  describe 'without parameters' do

    [
      'backends',
      'config',
      'commandtransports',
    ].each do | config_file |

      it {
        should contain_file("/etc/icingaweb2/modules/monitoring/#{config_file}.ini").
          with(
          {
            'owner' =>  'icingaweb2',
            'group' =>  'icingaweb2',
            'mode'  =>  '0644',
          }
        )
      }
    end

    it { should contain_ini_setting('security settings').with(
        'section' => /security/,
        'setting' => /protected_customvars/,
        'value'   => /community/,
        'path'    => /config.ini/
      )
    }
    it { should contain_ini_setting('backend ido setting').with(
        'section' => /icinga_ido/,
        'setting' => /type/,
        'value'   => /ido/,
        'path'    => /backends.ini/
      )
    }
    it { should contain_ini_setting('backend resource setting').with(
        'section' => /icinga_ido/,
        'setting' => /resource/,
        'value'   => /icinga_ido/,
        'path'    => /backends.ini/
      )
    }
    it { should contain_ini_setting('command transport setting').with(
        'section' => /icinga2/,
        'setting' => /transport/,
        'value'   => /local/,
	'path'    => /commandtransports.ini/

      )
    }

  end

end
