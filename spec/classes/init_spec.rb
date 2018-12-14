require 'spec_helper'
describe 'asterisk' do
  let(:title) { 'asterisk' }
  let(:facts) { {
    :operatingsystem => 'Debian',
  } }

  context 'with defaults for all parameters' do
    it { should contain_class('asterisk') }
  end
end
