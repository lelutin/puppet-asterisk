# frozen_string_literal: true

require 'spec_helper'

describe 'asterisk::registry::sip' do
  let(:title) { 'providerX' }

  let(:params) do
    {
      server: 'sip.providerx.com',
      user:   'myuser',
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:pre_condition) { 'include asterisk' }

      context 'with default parameter values' do
        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_asterisk__dotd__file('registry__sip_providerX.conf')
            .with(
              ensure:   'file',
              dotd_dir: 'sip.registry.d',
              filename: 'providerX.conf',
            )
            .with_content(%r{^register => myuser@sip\.providerx\.com$})
        end
      end

      context 'with ensure set to absent' do
        let(:params) { super().merge(ensure: 'absent') }

        it do
          is_expected.to contain_asterisk__dotd__file('registry__sip_providerX.conf')
            .with_ensure('absent')
        end
      end

      context 'with password parameter set without authuser' do
        let(:params) { super().merge(password: sensitive('secret')) }

        it do
          is_expected.to contain_asterisk__dotd__file('registry__sip_providerX.conf')
            .with_content(%r{^register => myuser:secret@sip\.providerx\.com$})
            .without_content(%r{^register => myuser:secret:[^@]+@})
        end
      end

      context 'with authuser parameter set' do
        let(:params) { super().merge(password: sensitive('secret'), authuser: 'myauthuser') }

        it do
          is_expected.to contain_asterisk__dotd__file('registry__sip_providerX.conf')
            .with_content(%r{^register => myuser:secret:myauthuser@sip\.providerx\.com$})
        end
      end

      context 'with port parameter set' do
        let(:params) { super().merge(port: 5060) }

        it do
          is_expected.to contain_asterisk__dotd__file('registry__sip_providerX.conf')
            .with_content(%r{^register => myuser@sip\.providerx\.com:5060$})
        end
      end

      context 'with extension parameter set' do
        let(:params) { super().merge(extension: '1234') }

        it do
          is_expected.to contain_asterisk__dotd__file('registry__sip_providerX.conf')
            .with_content(%r{^register => myuser@sip\.providerx\.com/1234$})
        end
      end

      context 'with authuser set but no password' do
        let(:params) { super().merge(authuser: 'myauthuser') }

        it { is_expected.to compile.and_raise_error(%r{authuser was specified but no value was given for password}) }
      end

      # This is redundant but it ensures that the ordering is all correct when
      # everything is supplied
      context 'with all optional parameters set' do
        let(:params) do
          super().merge(
            password:  sensitive('secret'),
            authuser:  'myauthuser',
            port:      5060,
            extension: '1234',
          )
        end

        it do
          is_expected.to contain_asterisk__dotd__file('registry__sip_providerX.conf')
            .with_content(%r{^register => myuser:secret:myauthuser@sip\.providerx\.com:5060/1234$})
        end
      end
    end
  end
end
