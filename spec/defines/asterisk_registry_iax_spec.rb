# frozen_string_literal: true

require 'spec_helper'

describe 'asterisk::registry::iax' do
  let(:title) { 'providerX' }

  let(:params) do
    {
      server:   'iax.providerx.com',
      user:     'myuser',
      password: sensitive('secret'),
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:pre_condition) { 'include asterisk' }

      context 'with default parameter values' do
        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_asterisk__dotd__file('registry__iax_providerX.conf')
            .with(
              ensure:   'file',
              dotd_dir: 'iax.registry.d',
              filename: 'providerX.conf',
            )
            .with_content(%r{^register => myuser:secret@iax\.providerx\.com$})
        end
      end

      context 'with ensure set to absent' do
        let(:params) { super().merge(ensure: 'absent') }

        it do
          is_expected.to contain_asterisk__dotd__file('registry__iax_providerX.conf')
            .with_ensure('absent')
        end
      end
    end
  end
end
