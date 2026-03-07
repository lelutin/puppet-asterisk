# frozen_string_literal: true

require 'spec_helper'

describe 'asterisk::manager' do
  let(:title) { 'sophie' }

  let(:params) do
    {
      secret: sensitive('youllneverguesswhatitis'),
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:pre_condition) { 'include asterisk' }

      context 'with default parameter values' do
        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_asterisk__dotd__file('manager_sophie.conf')
            .with(
              ensure:   'file',
              dotd_dir: 'manager.d',
              filename: 'sophie.conf',
            )
            .with_content(%r{^\[sophie\]$})
            .with_content(%r{^secret = youllneverguesswhatitis$})
            .with_content(%r{^deny = 0\.0\.0\.0/0\.0\.0\.0$})
            .with_content(%r{^permit = 127\.0\.0\.1/255\.255\.255\.255$})
            .with_content(%r{^read = system,call$})
            .with_content(%r{^write = system,call$})
            .with_content(%r{^writetimeout = 100$})
            .with_content(%r{^displayconnects = yes$})
            .without_content(%r{^eventfilter = })
        end
      end

      context 'with ensure set to absent' do
        let(:params) { super().merge(ensure: 'absent') }

        it do
          is_expected.to contain_asterisk__dotd__file('manager_sophie.conf')
            .with_ensure('absent')
        end
      end

      context 'with manager_name parameter set' do
        let(:params) { super().merge(manager_name: 'customname') }

        it do
          is_expected.to contain_asterisk__dotd__file('manager_sophie.conf')
            .with_content(%r{^\[customname\]$})
        end
      end

      context 'with secret parameter set' do
        let(:params) { super().merge(secret: sensitive('newsecret')) }

        it do
          is_expected.to contain_asterisk__dotd__file('manager_sophie.conf')
            .with_content(%r{^secret = newsecret$})
        end
      end

      context 'with deny parameter set' do
        let(:params) { super().merge(deny: ['192.168.0.0/255.255.0.0', '10.0.0.0/255.0.0.0']) }

        it do
          is_expected.to contain_asterisk__dotd__file('manager_sophie.conf')
            .with_content(%r{^deny = 192\.168\.0\.0/255\.255\.0\.0$})
            .with_content(%r{^deny = 10\.0\.0\.0/255\.0\.0\.0$})
        end
      end

      context 'with permit parameter set' do
        let(:params) { super().merge(permit: ['192.168.0.0/255.255.0.0', '10.0.0.0/255.0.0.0']) }

        it do
          is_expected.to contain_asterisk__dotd__file('manager_sophie.conf')
            .with_content(%r{^permit = 192\.168\.0\.0/255\.255\.0\.0$})
            .with_content(%r{^permit = 10\.0\.0\.0/255\.0\.0\.0$})
        end
      end

      context 'with read parameter set' do
        let(:params) { super().merge(read: %w[system call agent]) }

        it do
          is_expected.to contain_asterisk__dotd__file('manager_sophie.conf')
            .with_content(%r{^read = system,call,agent$})
        end
      end

      context 'with a write-only right given to read' do
        let(:params) { super().merge(read: %w[system config]) }

        it { is_expected.to compile.and_raise_error(%r{write-only right 'config' given to the \$read parameter}) }
      end

      context 'with write parameter set' do
        let(:params) { super().merge(write: %w[system call agent]) }

        it do
          is_expected.to contain_asterisk__dotd__file('manager_sophie.conf')
            .with_content(%r{^write = system,call,agent$})
        end
      end

      context 'with a read-only right given to write' do
        let(:params) { super().merge(write: %w[system log]) }

        it { is_expected.to compile.and_raise_error(%r{read-only right 'log' given to the \$write parameter}) }
      end

      context 'with writetimeout parameter set' do
        let(:params) { super().merge(writetimeout: 200) }

        it do
          is_expected.to contain_asterisk__dotd__file('manager_sophie.conf')
            .with_content(%r{^writetimeout = 200$})
        end
      end

      context 'with displayconnects parameter set to false' do
        let(:params) { super().merge(displayconnects: false) }

        it do
          is_expected.to contain_asterisk__dotd__file('manager_sophie.conf')
            .with_content(%r{^displayconnects = no$})
        end
      end

      context 'with eventfilter parameter set' do
        let(:params) { super().merge(eventfilter: '!Event: Hangup') }

        it do
          is_expected.to contain_asterisk__dotd__file('manager_sophie.conf')
            .with_content(%r{^eventfilter = !Event: Hangup$})
        end
      end
    end
  end
end
