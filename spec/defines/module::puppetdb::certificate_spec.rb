require 'spec_helper'

describe('icingaweb2::module::puppetdb::certificate', :type => :define) do
  let(:title) { 'mycertificate' }
  let(:pre_condition) { [
      "class { 'icingaweb2': }",
      "class { 'icingaweb2::module::puppetdb': }"
  ] }

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "required parameters not set" do
      it { is_expected.not_to  compile }
    end

    context "with ensure set to foobar" do
      let(:params) { { :ensure => 'foobar',
                       :ssl_key => '-----BEGIN RSA PRIVATE KEY----- ...',
                       :ssl_cacert => '-----BEGIN RSA PRIVATE KEY----- ...'  } }

      it { is_expected.to raise_error(Puppet::Error, /foobar isn't supported/) }
    end

    context "with ensure set to present" do
      let(:params) { { :ensure => 'present',
                       :ssl_key => '-----BEGIN RSA PRIVATE KEY----- ...',
                       :ssl_cacert => '-----BEGIN CERTIFICATE----- ...'  } }

      it { is_expected.to contain_file('/etc/icingaweb2/modules/puppetdb/ssl/mycertificate')
        .with_ensure('directory')
        .with_purge('true')
        .with_recurse('true')
        .with_group('icingaweb2')
        .with_mode('0740')
                       }

      case facts[:osfamily]
      when 'debian' then
        it { is_expected.to contain_file('/etc/icingaweb2/modules/puppetdb/ssl/mycertificate').with_owner('www-data') }
      when 'redhat' then
        it { is_expected.to contain_file('/etc/icingaweb2/modules/puppetdb/ssl/mycertificate').with_owner('apache') }
      when 'suse' then
        it { is_expected.to contain_file('/etc/icingaweb2/modules/puppetdb/ssl/mycertificate').with_owner('wwwrun') }
      end

      it { is_expected.to contain_file('/etc/icingaweb2/modules/puppetdb/ssl/mycertificate/private_keys')
        .with_ensure('directory')
                       }

      it { is_expected.to contain_file('/etc/icingaweb2/modules/puppetdb/ssl/mycertificate/private_keys/mycertificate_combined.pem')
        .with_ensure('present')
        .with_content('-----BEGIN RSA PRIVATE KEY----- ...')
                       }

      it { is_expected.to contain_file('/etc/icingaweb2/modules/puppetdb/ssl/mycertificate/certs')
        .with_ensure('directory')
                       }

      it { is_expected.to contain_file('/etc/icingaweb2/modules/puppetdb/ssl/mycertificate/certs/ca.pem')
        .with_ensure('present')
        .with_content('-----BEGIN CERTIFICATE----- ...')
                       }

    end

    context "with ensure set to absent" do
      let(:params) { { :ensure => 'absent',
                       :ssl_key => '-----BEGIN RSA PRIVATE KEY----- ...',
                       :ssl_cacert => '-----BEGIN RSA PRIVATE KEY----- ...'  } }

      it { is_expected.to contain_file('/etc/icingaweb2/modules/puppetdb/ssl/mycertificate')
        .with_ensure('absent')
        .with_purge('true')
        .with_recurse('true')
                       }
      it { is_expected.to contain_file('/etc/icingaweb2/modules/puppetdb/ssl/mycertificate/private_keys')
        .with_ensure('absent')
                       }

      it { is_expected.to contain_file('/etc/icingaweb2/modules/puppetdb/ssl/mycertificate/certs')
        .with_ensure('absent')
                       }
    end

  end
end
