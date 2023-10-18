require 'spec_helper'

describe('icingaweb2::config::navigation', type: :define) do
  let(:title) { 'myitem' }
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

      context "#{os} with private menu entry" do
        let(:params) do
          {
            owner: 'foobar',
            url: 'url',
            users: ['foo', 'bar'],
            groups: ['foobars'],
            parent: 'parent',
            filter: 'filter',
          }
        end

        it {
          is_expected.to contain_file('/etc/icingaweb2/preferences/foobar')
            .with_ensure('directory')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('navigation-myitem')
            .with_section_name('myitem')
            .with_target('/etc/icingaweb2/preferences/foobar/menu.ini')
            .with_settings({ 'type' => 'menu-item', 'target' => '_main', 'url' => 'url', 'parent' => 'parent' })
        }
      end

      context "#{os} with shared menu entry" do
        let(:params) do
          {
            owner: 'foobar',
            url: 'url',
            target: '_blank',
            shared: true,
            users: ['foo', 'bar'],
            groups: ['foobars'],
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('navigation-myitem')
            .with_section_name('myitem')
            .with_target('/etc/icingaweb2/navigation/menu.ini')
            .with_settings(
              {
                'type'   => 'menu-item',
                'target' => '_blank',
                'url'    => 'url',
                'users'  => 'foo, bar',
                'groups' => 'foobars',
                'owner'  => 'foobar',
              },
            )
        }
      end

      context "#{os} with shared menu entry and parent" do
        let(:params) do
          {
            owner: 'foobar',
            url: 'url',
            shared: true,
            users: ['foo', 'bar'],
            parent: 'parent',
            groups: ['foobars'],
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('navigation-myitem')
            .with_section_name('myitem')
            .with_target('/etc/icingaweb2/navigation/menu.ini')
            .with_settings(
              {
                'type'   => 'menu-item',
                'target' => '_main',
                'url'    => 'url',
                'parent' => 'parent',
                'owner'  => 'foobar',
              },
            )
        }
      end

      context "#{os} with private host action" do
        let(:params) do
          {
            type: 'host-action',
            owner: 'foobar',
            url: 'url',
            users: ['foo', 'bar'],
            groups: ['foobars'],
            parent: 'parent',
            filter: 'filter',
          }
        end

        it {
          is_expected.to contain_file('/etc/icingaweb2/preferences/foobar')
            .with_ensure('directory')
        }

        it {
          is_expected.to contain_icingaweb2__inisection('navigation-myitem')
            .with_section_name('myitem')
            .with_target('/etc/icingaweb2/preferences/foobar/host-actions.ini')
            .with_settings({ 'type' => 'host-action', 'target' => '_main', 'url' => 'url', 'filter' => 'filter' })
        }
      end

      context "#{os} with shared service action" do
        let(:params) do
          {
            type: 'service-action',
            owner: 'foobar',
            parent: 'parent',
            url: 'url',
            target: '_blank',
            shared: true,
            users: ['foo', 'bar'],
            groups: ['foobars'],
            filter: 'filter',
          }
        end

        it {
          is_expected.to contain_icingaweb2__inisection('navigation-myitem')
            .with_section_name('myitem')
            .with_target('/etc/icingaweb2/navigation/service-actions.ini')
            .with_settings(
              {
                'type'   => 'service-action',
                'target' => '_blank',
                'url'    => 'url',
                'users'  => 'foo, bar',
                'groups' => 'foobars',
                'filter' => 'filter',
                'owner'  => 'foobar',
              },
            )
        }
      end
    end
  end
end
