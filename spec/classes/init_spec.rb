require 'spec_helper'
describe 'asterisk' do
  let(:title) { 'asterisk' }
  let(:facts) do
    {
      os: {
        family: 'Debian',
      },
    }
  end

  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('asterisk') }
  end
end
