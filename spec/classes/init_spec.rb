require 'spec_helper'
describe 'cust_mysql' do
  context 'with default values for all parameters' do
    it { should contain_class('cust_mysql') }
  end
end
