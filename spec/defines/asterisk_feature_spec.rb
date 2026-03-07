# frozen_string_literal: true

require 'spec_helper'

describe 'asterisk::feature' do
  let(:title) { 'shifteight' }

  let(:params) do
    {
      options: {
        'unpauseMonitor' => '*1',
        'pauseMonitor'   => '*2',
      },
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:pre_condition) { 'include asterisk' }

      context 'with default parameter values' do
        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_asterisk__dotd__file('featuremap_group_shifteight.conf')
            .with(
              ensure:   'file',
              dotd_dir: 'features.d',
              filename: 'shifteight.conf',
            )
            .with_content(%r{^\[shifteight\]$})
            .with_content(%r{^unpauseMonitor => \*1$})
            .with_content(%r{^pauseMonitor => \*2$})
        end
      end

      context 'with ensure set to absent' do
        let(:params) { super().merge(ensure: 'absent') }

        it do
          is_expected.to contain_asterisk__dotd__file('featuremap_group_shifteight.conf')
            .with_ensure('absent')
        end
      end

      context 'with options set to an empty hash' do
        let(:params) { { options: {} } }

        it do
          is_expected.to contain_asterisk__dotd__file('featuremap_group_shifteight.conf')
            .with_content(%r{^\[shifteight\]$})
            .without_content(%r{ => })
        end
      end
    end
  end
end
