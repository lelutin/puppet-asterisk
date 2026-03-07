# frozen_string_literal: true

require 'spec_helper'

describe 'asterisk::voicemail' do
  let(:title) { '3000' }

  let(:params) do
    {
      context:  'default',
      password: sensitive('1234'),
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:pre_condition) { 'include asterisk' }

      context 'with default parameter values' do
        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_asterisk__dotd__file('default-3000.conf')
            .with(
              ensure: 'file',
              dotd_dir: 'voicemail.d',
            )
            .with_content(%r{^\[default\]$})
            .with_content(%r{^3000 => 1234,,,$})
        end
      end

      context 'with ensure set to absent' do
        let(:params) do
          super().merge(ensure: 'absent')
        end

        it do
          is_expected.to contain_asterisk__dotd__file('default-3000.conf')
            .with_ensure('absent')
        end
      end

      context 'with user_name parameter set' do
        let(:params) do
          super().merge(user_name: 'John Doe')
        end

        it do
          is_expected.to contain_asterisk__dotd__file('default-3000.conf')
            .with_content(%r{^3000 => 1234,John Doe,,})
        end
      end

      context 'with email parameter set' do
        let(:params) do
          super().merge(email: 'john@example.com')
        end

        it do
          is_expected.to contain_asterisk__dotd__file('default-3000.conf')
            .with_content(%r{^3000 => 1234,,john@example\.com,})
        end
      end

      context 'with pager_email parameter set' do
        let(:params) do
          super().merge(pager_email: 'pager@example.com')
        end

        it do
          is_expected.to contain_asterisk__dotd__file('default-3000.conf')
            .with_content(%r{^3000 => 1234,,,pager@example\.com})
        end
      end

      context 'with options parameter set' do
        let(:params) do
          super().merge(options: { 'tz' => 'central', 'attach' => 'yes' })
        end

        it do
          is_expected.to contain_asterisk__dotd__file('default-3000.conf')
            .with_content(%r{^3000 => 1234,,,,tz=central\|attach=yes})
        end
      end

      context 'with all optional parameters set' do
        let(:params) do
          super().merge(
            user_name:   'John Doe',
            email:       'john@example.com',
            pager_email: 'pager@example.com',
            options:     { 'tz' => 'central', 'attach' => 'yes' },
          )
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_asterisk__dotd__file('default-3000.conf')
            .with_content(%r{^3000 => 1234,John Doe,john@example\.com,pager@example\.com,tz=central\|attach=yes})
        end
      end

      context 'with a different context' do
        let(:params) do
          super().merge(context: 'support')
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_asterisk__dotd__file('support-3000.conf')
            .with_content(%r{^\[support\]$})
        end
      end
    end
  end
end
