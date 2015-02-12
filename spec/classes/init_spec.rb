require 'spec_helper'
describe 'icingaweb2' do

  context 'with defaults for all parameters' do
    it { should contain_class('icingaweb2') }
  end
end
