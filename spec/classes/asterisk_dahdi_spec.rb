# frozen_string_literal: true

require 'spec_helper'

describe 'asterisk::dahdi' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('asterisk::dahdi') }
        it { is_expected.to contain_package('asterisk-dahdi').with_ensure('installed') }
        it { is_expected.to contain_package('dahdi').with_ensure('installed') }
        it { is_expected.to contain_package('dahdi-dkms').with_ensure('installed') }
        it { is_expected.to contain_package('dahdi-linux').with_ensure('installed') }
        it { is_expected.to contain_package('dahdi-source').with_ensure('installed') }
      end
    end
  end
end
