# frozen_string_literal: true

require 'spec_helper'

describe 'asterisk::queue' do
  let(:title) { 'frontline' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:pre_condition) { 'include asterisk' }

      context 'with default parameter values' do
        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with(
              ensure:   'file',
              dotd_dir: 'queues.d',
              filename: 'frontline.conf',
            )
            .with_content(%r{^\[frontline\]$})
            .without_content(%r{^strategy=})
            .without_content(%r{^member=})
            .without_content(%r{^joinempty=})
            .without_content(%r{^leavewhenempty=})
            .without_content(%r{^monitor-format=})
            .without_content(%r{^periodic-announce=})
        end
      end

      context 'with ensure set to absent' do
        let(:params) { { ensure: 'absent' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_ensure('absent')
        end
      end

      context 'with strategy parameter set' do
        let(:params) { { strategy: 'rrmemory' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^strategy=rrmemory$})
        end
      end

      context 'with members parameter set' do
        let(:params) { { members: ['SIP/reception', 'SIP/secretary'] } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^member=SIP/reception$})
            .with_content(%r{^member=SIP/secretary$})
        end
      end

      context 'with memberdelay parameter set' do
        let(:params) { { memberdelay: 5 } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^memberdelay=5$})
        end
      end

      context 'with penaltymemberslimit parameter set' do
        let(:params) { { penaltymemberslimit: '5' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^penaltymemberslimit=5$})
        end
      end

      context 'with membermacro parameter set' do
        let(:params) { { membermacro: 'mymacro' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^membermacro=mymacro$})
        end
      end

      context 'with membergosub parameter set' do
        let(:params) { { membergosub: 'mygosub' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^membergosub=mygosub$})
        end
      end

      context 'with context parameter set' do
        let(:params) { { context: 'exitcontext' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^context=exitcontext$})
        end
      end

      context 'with defaultrule parameter set' do
        let(:params) { { defaultrule: 'myrule' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^defaultrule=myrule$})
        end
      end

      context 'with maxlen parameter set' do
        let(:params) { { maxlen: 10 } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^maxlen=10$})
        end
      end

      context 'with musicclass parameter set' do
        let(:params) { { musicclass: 'default' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^musicclass=default$})
        end
      end

      context 'with servicelevel parameter set' do
        let(:params) { { servicelevel: '60' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^servicelevel=60$})
        end
      end

      context 'with weight parameter set' do
        let(:params) { { weight: 10 } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^weight=10$})
        end
      end

      context 'with joinempty parameter set' do
        let(:params) { { joinempty: %w[unavailable invalid] } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^joinempty=unavailable,invalid$})
        end
      end

      context 'with leavewhenempty parameter set' do
        let(:params) { { leavewhenempty: %w[unavailable invalid] } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^leavewhenempty=unavailable,invalid$})
        end
      end

      context 'with eventwhencalled parameter set' do
        let(:params) { { eventwhencalled: 'yes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^eventwhencalled=yes$})
        end
      end

      context 'with eventmemberstatus parameter set' do
        let(:params) { { eventmemberstatus: 'yes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^eventmemberstatus=yes$})
        end
      end

      context 'with reportholdtime parameter set' do
        let(:params) { { reportholdtime: 'yes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^reportholdtime=yes$})
        end
      end

      context 'with ringinuse parameter set' do
        let(:params) { { ringinuse: 'no' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^ringinuse=no$})
        end
      end

      context 'with monitor_type parameter set' do
        let(:params) { { monitor_type: 'MixMonitor' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^monitor-type=MixMonitor$})
        end
      end

      context 'with monitor_format parameter set' do
        let(:params) { { monitor_format: %w[wav gsm] } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^monitor-format=wav\|gsm$})
        end
      end

      context 'with announce parameter set' do
        let(:params) { { announce: 'queue-announce' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^announce=queue-announce$})
        end
      end

      context 'with announce_frequency parameter set' do
        let(:params) { { announce_frequency: 30 } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^announce-frequency=30$})
        end
      end

      context 'with min_announce_frequency parameter set' do
        let(:params) { { min_announce_frequency: 15 } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^min-announce-frequency=15$})
        end
      end

      context 'with announce_holdtime parameter set' do
        let(:params) { { announce_holdtime: 'yes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^announce-holdtime=yes$})
        end
      end

      context 'with announce_position parameter set' do
        let(:params) { { announce_position: 'limit' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^announce-position=limit$})
        end
      end

      context 'with announce_position_limit parameter set' do
        let(:params) { { announce_position_limit: 5 } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^announce-position-limit=5$})
        end
      end

      context 'with announce_round_seconds parameter set' do
        let(:params) { { announce_round_seconds: 10 } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^announce-round-seconds=10$})
        end
      end

      context 'with periodic_announce parameter set' do
        let(:params) { { periodic_announce: %w[queue-periodic-announce queue-thankyou] } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^periodic-announce=queue-periodic-announce,queue-thankyou$})
        end
      end

      context 'with periodic_announce_frequency parameter set' do
        let(:params) { { periodic_announce_frequency: 60 } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^periodic-announce-frequency=60$})
        end
      end

      context 'with random_periodic_announce parameter set' do
        let(:params) { { random_periodic_announce: 'yes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^random-periodic-announce=yes$})
        end
      end

      context 'with relative_periodic_announce parameter set' do
        let(:params) { { relative_periodic_announce: 'yes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^relative-periodic-announce=yes$})
        end
      end

      context 'with queue_youarenext parameter set' do
        let(:params) { { queue_youarenext: 'custom-youarenext' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-youarenext=custom-youarenext$})
        end
      end

      context 'with queue_youarenext set to an empty string' do
        let(:params) { { queue_youarenext: '' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-youarenext=$})
        end
      end

      context 'with queue_thereare parameter set' do
        let(:params) { { queue_thereare: 'custom-thereare' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-thereare=custom-thereare$})
        end
      end

      context 'with queue_thereare set to an empty string' do
        let(:params) { { queue_thereare: '' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-thereare=$})
        end
      end

      context 'with queue_callswaiting parameter set' do
        let(:params) { { queue_callswaiting: 'custom-callswaiting' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-callswaiting=custom-callswaiting$})
        end
      end

      context 'with queue_callswaiting set to an empty string' do
        let(:params) { { queue_callswaiting: '' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-callswaiting=$})
        end
      end

      context 'with queue_holdtime parameter set' do
        let(:params) { { queue_holdtime: 'custom-holdtime' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-holdtime=custom-holdtime$})
        end
      end

      context 'with queue_holdtime set to an empty string' do
        let(:params) { { queue_holdtime: '' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-holdtime=$})
        end
      end

      context 'with queue_minute parameter set' do
        let(:params) { { queue_minute: 'custom-minute' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-minute=custom-minute$})
        end
      end

      context 'with queue_minute set to an empty string' do
        let(:params) { { queue_minute: '' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-minute=$})
        end
      end

      context 'with queue_minutes parameter set' do
        let(:params) { { queue_minutes: 'custom-minutes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-minutes=custom-minutes$})
        end
      end

      context 'with queue_minutes set to an empty string' do
        let(:params) { { queue_minutes: '' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-minutes=$})
        end
      end

      context 'with queue_seconds parameter set' do
        let(:params) { { queue_seconds: 'custom-seconds' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-seconds=custom-seconds$})
        end
      end

      context 'with queue_seconds set to an empty string' do
        let(:params) { { queue_seconds: '' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-seconds=$})
        end
      end

      context 'with queue_thankyou parameter set' do
        let(:params) { { queue_thankyou: 'custom-thankyou' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-thankyou=custom-thankyou$})
        end
      end

      context 'with queue_thankyou set to an empty string' do
        let(:params) { { queue_thankyou: '' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-thankyou=$})
        end
      end

      context 'with queue_reporthold parameter set' do
        let(:params) { { queue_reporthold: 'custom-reporthold' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-reporthold=custom-reporthold$})
        end
      end

      context 'with queue_reporthold set to an empty string' do
        let(:params) { { queue_reporthold: '' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^queue-reporthold=$})
        end
      end

      context 'with wrapuptime parameter set' do
        let(:params) { { wrapuptime: 10 } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^wrapuptime=10$})
        end
      end

      context 'with timeout parameter set' do
        let(:params) { { timeout: 30 } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^timeout=30$})
        end
      end

      context 'with timeoutrestart parameter set' do
        let(:params) { { timeoutrestart: 'yes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^timeoutrestart=yes$})
        end
      end

      context 'with timeoutpriority parameter set' do
        let(:params) { { timeoutpriority: 'conf' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^timeoutpriority=conf$})
        end
      end

      context 'with retry parameter set' do
        let(:params) { { retry: '5' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^retry=5$})
        end
      end

      context 'with autofill parameter set' do
        let(:params) { { autofill: 'yes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^autofill=yes$})
        end
      end

      context 'with autopause parameter set' do
        let(:params) { { autopause: 'yes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^autopause=yes$})
        end
      end

      context 'with setinterfacevar parameter set' do
        let(:params) { { setinterfacevar: 'yes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^setinterfacevar=yes$})
        end
      end

      context 'with setqueuevar parameter set' do
        let(:params) { { setqueuevar: 'yes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^setqueuevar=yes$})
        end
      end

      context 'with setqueueentryvar parameter set' do
        let(:params) { { setqueueentryvar: 'yes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('queue_frontline.conf')
            .with_content(%r{^setqueueentryvar=yes$})
        end
      end
    end
  end
end
