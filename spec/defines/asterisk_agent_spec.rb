# frozen_string_literal: true

require 'spec_helper'

describe 'asterisk::agent' do
  let(:title) { 'provocateur' }

  let(:params) do
    {
      ext:        '700',
      password:   sensitive('supersecret'),
      agent_name: 'provocateur',
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:pre_condition) { 'include asterisk' }

      context 'with default parameter values' do
        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_asterisk__dotd__file('agent_provocateur.conf')
            .with(
              ensure:   'file',
              dotd_dir: 'agents.d',
              filename: 'provocateur.conf',
            )
            .with_content(%r{^agent => 700,supersecret,provocateur$})
            .without_content(%r{^group=})
        end
      end

      context 'with ensure set to absent' do
        let(:params) { super().merge(ensure: 'absent') }

        it do
          is_expected.to contain_asterisk__dotd__file('agent_provocateur.conf')
            .with_ensure('absent')
        end
      end

      context 'with ext parameter set' do
        let(:params) { super().merge(ext: '800') }

        it do
          is_expected.to contain_asterisk__dotd__file('agent_provocateur.conf')
            .with_content(%r{^agent => 800,supersecret,provocateur$})
        end
      end

      context 'with password parameter set' do
        let(:params) { super().merge(password: sensitive('newpassword')) }

        it do
          is_expected.to contain_asterisk__dotd__file('agent_provocateur.conf')
            .with_content(%r{^agent => 700,newpassword,provocateur$})
        end
      end

      context 'with agent_name parameter set' do
        let(:params) { super().merge(agent_name: 'double') }

        it do
          is_expected.to contain_asterisk__dotd__file('agent_provocateur.conf')
            .with_content(%r{^agent => 700,supersecret,double$})
        end
      end

      context 'with groups parameter set' do
        let(:params) { super().merge(groups: %w[1 2]) }

        it do
          is_expected.to contain_asterisk__dotd__file('agent_provocateur.conf')
            .with_content(%r{^group=1,2\nagent => 700,supersecret,provocateur\n; Reset group to avoid having an impact on other config files\.\ngroup=$})
        end
      end
    end
  end
end
