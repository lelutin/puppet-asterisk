# frozen_string_literal: true

require 'spec_helper'

describe 'asterisk::extensions' do
  let(:title) { 'incoming' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:pre_condition) { 'include asterisk' }

      context 'with default parameter values' do
        it { is_expected.to compile.and_raise_error(%r{One of \$content or \$source need to be defined, none were set}) }
      end

      context 'with both source and content set' do
        let(:params) do
          {
            source:  'puppet:///modules/site_asterisk/extensions/incoming',
            content: 'exten => 666,1,Hangup()',
          }
        end

        it { is_expected.to compile.and_raise_error(%r{Please provide either a \$source or a \$content, but not both\.}) }
      end

      context 'with ensure set to absent' do
        let(:params) { { ensure: 'absent', source: 'puppet:///modules/site_asterisk/extensions/incoming' } }

        it do
          is_expected.to contain_asterisk__dotd__file('extensions_incoming.conf')
            .with_ensure('absent')
        end
      end

      context 'with source parameter set' do
        let(:params) { { source: 'puppet:///modules/site_asterisk/extensions/incoming' } }

        it do
          is_expected.to contain_asterisk__dotd__file('extensions_incoming.conf')
            .with(
              ensure:   'file',
              dotd_dir: 'extensions.d',
              filename: 'incoming.conf',
            )
            .with_source('puppet:///modules/site_asterisk/extensions/incoming')
            .with_content(nil)
        end
      end

      context 'with content parameter set' do
        let(:params) { { content: 'exten => 666,1,Hangup()' } }

        it do
          is_expected.to contain_asterisk__dotd__file('extensions_incoming.conf')
            .with(
              ensure:   'file',
              dotd_dir: 'extensions.d',
              filename: 'incoming.conf',
            )
            .with_content("[incoming]\nexten => 666,1,Hangup()")
            .with_source(nil)
        end
      end

      context 'with content set to an empty string' do
        let(:params) { { content: '' } }

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_asterisk__dotd__file('extensions_incoming.conf')
            .with_content("[incoming]\n")
            .with_source(nil)
        end
      end
    end
  end
end
