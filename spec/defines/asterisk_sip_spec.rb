# frozen_string_literal: true

require 'spec_helper'

describe 'asterisk::sip' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'mypeer' }
      let(:pre_condition) { 'include asterisk' }

      context 'with default parameter values' do
        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with(
              ensure: 'file',
              dotd_dir: 'sip.d',
              filename: 'mypeer.conf',
            )
        end

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^\[mypeer\]$})
            .with_content(%r{^type=friend$})
            .with_content(%r{^directmedia=no$})
            .with_content(%r{^directrtpsetup=yes$})
            .with_content(%r{^host=dynamic$})
            .with_content(%r{^insecure=no$})
            .with_content(%r{^language=en$})
            .with_content(%r{^qualify=no$})
        end
      end

      context 'with ensure set to absent' do
        let(:params) do
          {
            ensure: 'absent',
          }
        end

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_ensure('absent')
        end
      end

      context 'with template_name parameter set' do
        let(:params) { { template_name: 'corporate_user' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^\[mypeer\]\(corporate_user\)$})
        end
      end

      context 'with account_type parameter set' do
        let(:params) { { account_type: 'peer' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^type=peer$})
        end
      end

      context 'with username parameter set' do
        let(:params) { { username: 'myuser' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^username=myuser$})
        end
      end

      context 'with defaultuser parameter set' do
        let(:params) { { defaultuser: 'mydefaultuser' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^defaultuser=mydefaultuser$})
        end
      end

      context 'with secret parameter set' do
        let(:params) { { secret: sensitive('mysecret') } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^secret=mysecret$})
        end
      end

      context 'with md5secret parameter set' do
        let(:params) { { md5secret: 'abc123def456' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^md5secret=abc123def456$})
        end
      end

      context 'with remotesecret parameter set' do
        let(:params) { { remotesecret: sensitive('myremotesecret') } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^secret=myremotesecret$})
        end
      end

      context 'with context parameter set' do
        let(:params) { { context: 'incoming' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^context=incoming$})
        end
      end

      context 'with canreinvite parameter set' do
        let(:params) { { canreinvite: 'no' } }

        before { Puppet.settings[:strict] = :warning }
        after  { Puppet.settings[:strict] = :error }

        it 'expects a deprecation notice' do
          logs = []
          Puppet::Util::Log.newdestination(Puppet::Test::LogCollector.new(logs))
          catalogue
          Puppet::Util::Log.close_all
          expect(logs).to include(an_object_having_attributes(level: :warning, message: include('canreinvite')))
        end

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^canreinvite=no$})
        end
      end

      context 'with directmedia parameter set' do
        let(:params) { { directmedia: 'nonat' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^directmedia=nonat$})
        end
      end

      context 'with directrtpsetup parameter set' do
        let(:params) { { directrtpsetup: false } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^directrtpsetup=no$})
        end
      end

      context 'with directmediadeny parameter set' do
        let(:params) { { directmediadeny: ['172.16.0.0/16', '10.0.0.0/8'] } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^directmediadeny=172\.16\.0\.0/16$})
            .with_content(%r{^directmediadeny=10\.0\.0\.0/8$})
        end
      end

      context 'with directmediapermit parameter set' do
        let(:params) { { directmediapermit: ['172.16.0.0/16', '10.0.0.0/8'] } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^directmediapermit=172\.16\.0\.0/16$})
            .with_content(%r{^directmediapermit=10\.0\.0\.0/8$})
        end
      end

      context 'with host parameter set' do
        let(:params) { { host: 'sip.provider.com' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^host=sip\.provider\.com$})
        end
      end

      context 'with insecure parameter set' do
        let(:params) { { insecure: 'port' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^insecure=port$})
        end
      end

      context 'with language parameter set' do
        let(:params) { { language: 'fr' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^language=fr$})
        end
      end

      context 'with nat parameter set' do
        let(:params) { { nat: 'force_rport' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^nat=force_rport$})
        end
      end

      context 'with qualify parameter set' do
        let(:params) { { qualify: 'yes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^qualify=yes$})
        end
      end

      context 'with vmexten parameter set' do
        let(:params) { { vmexten: '*97' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^vmexten=\*97$})
        end
      end

      context 'with fromdomain parameter set' do
        let(:params) { { fromdomain: 'example.com' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^fromdomain=example\.com$})
        end
      end

      context 'with fromuser parameter set' do
        let(:params) { { fromuser: 'myuser' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^fromuser=myuser$})
        end
      end

      context 'with outboundproxy parameter set' do
        let(:params) { { account_type: 'peer', outboundproxy: 'proxy.example.com' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^outboundproxy=proxy\.example\.com$})
        end
      end

      context 'with callerid parameter set' do
        let(:params) { { callerid: 'John Doe <1234>' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^callerid=John Doe <1234>$})
        end
      end

      context 'with call_limit parameter set' do
        let(:params) { { call_limit: 5 } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^call-limit=5$})
        end
      end

      context 'with callgroup parameter set' do
        let(:params) { { callgroup: '1' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^callgroup=1$})
        end
      end

      context 'with t38pt_udptl parameter set' do
        let(:params) { { t38pt_udptl: 'yes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^t38pt_udptl=yes$})
        end
      end

      context 'with mailbox parameter set' do
        let(:params) { { mailbox: '3000@default' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^mailbox=3000@default$})
        end
      end

      context 'with pickupgroup parameter set' do
        let(:params) { { pickupgroup: '1' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^pickupgroup=1$})
        end
      end

      context 'with disallow parameter set' do
        let(:params) { { disallow: %w[all g729] } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^disallow=all$})
            .with_content(%r{^disallow=g729$})
        end
      end

      context 'with allow parameter set' do
        let(:params) { { allow: %w[ulaw alaw] } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^allow=ulaw$})
            .with_content(%r{^allow=alaw$})
        end
      end

      context 'with dtmfmode parameter set' do
        let(:params) { { dtmfmode: 'info' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^dtmfmode=info$})
        end
      end

      context 'with transports parameter set' do
        let(:params) { { transports: %w[tcp udp] } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^transport=tcp,udp$})
        end
      end

      context 'with encryption parameter set' do
        let(:params) { { encryption: 'yes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^encryption=yes$})
        end
      end

      context 'with trustrpid parameter set' do
        let(:params) { { trustrpid: 'yes' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^trustrpid=yes$})
        end
      end

      context 'with sendrpid parameter set' do
        let(:params) { { sendrpid: 'pai' } }

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^sendrpid=pai$})
        end
      end

      context 'with access parameter set' do
        let(:params) do
          {
            access: [
              { 'permit' => '192.168.0.0/255.255.0.0' },
              { 'deny'   => '10.0.0.0/255.0.0.0' },
            ],
          }
        end

        it do
          is_expected.to contain_asterisk__dotd__file('sip_mypeer.conf')
            .with_content(%r{^permit=192\.168\.0\.0/255\.255\.0\.0$})
            .with_content(%r{^deny=10\.0\.0\.0/255\.0\.0\.0$})
        end
      end
    end
  end
end
