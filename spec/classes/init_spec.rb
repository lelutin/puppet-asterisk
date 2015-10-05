require 'spec_helper'
describe 'asterisk' do

  context 'with defaults for all parameters' do
    it { should contain_class('asterisk') }
  end
end
