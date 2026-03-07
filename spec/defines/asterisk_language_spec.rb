# frozen_string_literal: true

require 'spec_helper'

describe 'asterisk::language' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with a language pack name' do
        let(:title) { 'de' }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_package('asterisk-prompt-de').with_ensure('installed') }
        it { is_expected.not_to contain_package('asterisk-de') }
      end

      context 'with a core sounds language pack name' do
        let(:title) { 'core-sounds-en' }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_package('asterisk-core-sounds-en').with_ensure('installed') }
        it { is_expected.not_to contain_package('asterisk-prompt-core-sounds-en') }
      end

      context 'with an unsupported language name' do
        let(:title) { 'klingon' }

        it { is_expected.to compile.and_raise_error(%r{Language 'klingon' for Asterisk is unsupported\.}) }
      end
    end
  end
end
