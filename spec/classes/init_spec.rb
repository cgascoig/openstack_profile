require 'spec_helper'
describe 'openstack_profile' do

  context 'with defaults for all parameters' do
    it { should contain_class('openstack_profile') }
  end
end
