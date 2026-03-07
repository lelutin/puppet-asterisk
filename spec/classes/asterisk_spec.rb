# frozen_string_literal: true

require 'spec_helper'

describe 'asterisk' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('asterisk') }
        it { is_expected.to contain_class('asterisk::install') }
        it { is_expected.to contain_class('asterisk::config').that_notifies('Class[asterisk::service]') }
        it { is_expected.to contain_class('asterisk::service') }

        it { is_expected.to contain_file('/etc/asterisk').with_ensure('directory') }

        it do
          is_expected.to contain_file('/etc/asterisk')
            .with_ensure('directory')
            .without_purge
        end

        it { is_expected.to contain_service('asterisk').with_ensure('running') }
        it { is_expected.to contain_package('asterisk').with_ensure('installed') }
      end

      # -----------------------------------------------------------------------
      # Global management options
      # -----------------------------------------------------------------------
      context 'with manage_service => false' do
        let(:params) { { manage_service: false } }

        it { is_expected.not_to contain_service('asterisk') }
      end

      context 'with manage_package => false' do
        let(:params) { { manage_package: false } }

        it { is_expected.not_to contain_package('asterisk') }
      end

      context 'with a custom package_name' do
        let(:params) { { package_name: 'asterisk-custom' } }

        it { is_expected.to contain_package('asterisk-custom').with_ensure('installed') }
      end

      context 'with package_name as an array' do
        let(:params) { { package_name: %w[asterisk asterisk-extra] } }

        it { is_expected.to contain_package('asterisk') }
        it { is_expected.to contain_package('asterisk-extra') }
      end

      context 'with a custom service_name' do
        let(:params) { { service_name: 'asterisk-myservice' } }

        it { is_expected.to contain_service('asterisk-myservice') }
      end

      context 'with custom confdir' do
        let(:params) { { confdir: '/opt/asterisk/etc' } }

        it { is_expected.to contain_file('/opt/asterisk/etc').with_ensure('directory') }
      end

      context 'with purge_confdir => true' do
        let(:params) { { purge_confdir: true } }

        it do
          is_expected.to contain_file('/etc/asterisk')
            .with_ensure('directory')
            .with_purge(true)
            .with_recurse(true)
        end
      end

      # -----------------------------------------------------------------------
      # Asterisk modules and applications
      # -----------------------------------------------------------------------
      # Should not crash if not all of the array elements are supplied
      context 'with iax_general as an empty hash' do
        let(:params) { { iax_general: {} } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/asterisk/iax.conf').with_content(%r{^\[general\]$}) }
      end

      context 'with iax_general parameter set' do
        let(:params) do
          {
            iax_general: {
              'allow' => %w[ulaw alaw],
              'bandwidth' => 'high',
              'jitterbuffer' => 'yes',
            },
          }
        end

        it do
          is_expected.to contain_file('/etc/asterisk/iax.conf')
            .with_content(%r{^bandwidth=high$})
            .with_content(%r{^jitterbuffer=yes$})
            .with_content(%r{^allow=ulaw$})
            .with_content(%r{^allow=alaw$})
        end
      end

      context 'with iax_contexts parameter set' do
        let(:params) do
          {
            iax_contexts: {
              'provider1' => { 'source' => 'puppet:///modules/site_asterisk/provider1' },
              'provider2' => { 'source' => 'puppet:///modules/site_asterisk/provider2' },
            },
          }
        end

        it { is_expected.to contain_asterisk__iax('provider1').with_source('puppet:///modules/site_asterisk/provider1') }
        it { is_expected.to contain_asterisk__iax('provider2').with_source('puppet:///modules/site_asterisk/provider2') }
      end

      context 'with iax_registries parameter set' do
        let(:params) do
          {
            iax_registries: {
              'providerX' => {
                'server'   => 'iax.providerx.com',
                'user'     => 'myuser',
                'password' => sensitive('secret'),
              },
              'providerY' => {
                'server'   => 'iax.providery.com',
                'user'     => 'myotheruser',
                'password' => sensitive('evenmoresecret'),
              },
            },
          }
        end

        it do
          is_expected.to contain_asterisk__registry__iax('providerX')
            .with(
              'server' => 'iax.providerx.com',
              'user' => 'myuser',
              'password' => sensitive('secret'),
            )
        end

        it do
          is_expected.to contain_asterisk__registry__iax('providerY')
            .with(
              'server' => 'iax.providery.com',
              'user' => 'myotheruser',
              'password' => sensitive('evenmoresecret'),
            )
        end
      end

      # Should not crash if not all of the array elements are supplied
      context 'with sip_general as an empty hash' do
        let(:params) { { sip_general: {} } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/asterisk/sip.conf').with_content(%r{^\[general\]$}) }
      end

      context 'with sip_general parameter set' do
        let(:params) do
          {
            sip_general: {
              'localnet' => ['192.168.0.0/255.255.0.0', '10.0.0.0/255.0.0.0'],
              'context' => 'incoming',
              'tcpenable' => 'yes',
            },
          }
        end

        it do
          is_expected.to contain_file('/etc/asterisk/sip.conf')
            .with_content(%r{^context=incoming$})
            .with_content(%r{^tcpenable=yes$})
            .with_content(%r{^localnet=192\.168\.0\.0/255\.255\.0\.0$})
            .with_content(%r{^localnet=10\.0\.0\.0/255\.0\.0\.0$})
        end
      end

      context 'with sip_peers parameter set' do
        let(:params) do
          {
            sip_peers: {
              'alice' => {
                'secret'  => sensitive('topsecret'),
                'context' => 'incoming',
              },
              'bob' => {
                'secret'  => sensitive('anothersecret'),
                'context' => 'lost',
              },
            },
          }
        end

        it do
          is_expected.to contain_asterisk__sip('alice')
            .with(
              'secret' => sensitive('topsecret'),
              'context' => 'incoming',
            )
        end

        it do
          is_expected.to contain_asterisk__sip('bob')
            .with(
              'secret' => sensitive('anothersecret'),
              'context' => 'lost',
            )
        end
      end

      context 'with sip_registries parameter set' do
        let(:params) do
          {
            sip_registries: {
              'providerX' => {
                'server'   => 'sip.providerx.com',
                'user'     => 'myuser',
                'password' => sensitive('secret'),
              },
              'providerY' => {
                'server'   => 'sip.providery.com',
                'user'     => 'provyuser',
                'password' => sensitive('IsharedthisWithEverybody'),
              },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_asterisk__registry__sip('providerX')
            .with(
              'server' => 'sip.providerx.com',
              'user' => 'myuser',
              'password' => sensitive('secret'),
            )
        end

        it do
          is_expected.to contain_asterisk__registry__sip('providerY')
            .with(
              'server' => 'sip.providery.com',
              'user' => 'provyuser',
              'password' => sensitive('IsharedthisWithEverybody'),
            )
        end
      end

      context 'with voicemail_general parameter set' do
        let(:params) do
          {
            voicemail_general: {
              'format'    => 'wav',
              'maxlogins' => 5,
            },
          }
        end

        it do
          is_expected.to contain_file('/etc/asterisk/voicemail.conf')
            .with_content(%r{^format=wav$})
            .with_content(%r{^maxlogins=5$})
        end
      end

      context 'with voicemails parameter set' do
        let(:params) do
          {
            voicemails: {
              '3000' => {
                'context'  => 'some_context',
                'password' => sensitive('1234'),
              },
              '3001' => {
                'context'  => 'thensome_context',
                'password' => sensitive('5678'),
              },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_asterisk__voicemail('3000')
            .with(
              'context' => 'some_context',
              'password' => sensitive('1234'),
            )
        end

        it do
          is_expected.to contain_asterisk__voicemail('3001')
            .with(
              'context' => 'thensome_context',
              'password' => sensitive('5678'),
            )
        end
      end

      context 'with extensions_general parameter set' do
        let(:params) do
          {
            extensions_general: {
              'static'       => 'no',
              'writeprotect' => 'yes',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/extensions.conf')
            .with_content(%r{^static=no$})
            .with_content(%r{^writeprotect=yes$})
        end
      end

      context 'with extensions_global parameter set' do
        let(:params) do
          {
            extensions_globals: {
              'CONSOLE' => 'Console/dsp',
              'TRUNK'   => 'DAHDI/G2',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/extensions.conf')
            .with_content(%r{^CONSOLE=Console/dsp$})
            .with_content(%r{^TRUNK=DAHDI/G2$})
        end
      end

      context 'with extension_contexts parameter set' do
        let(:params) do
          {
            extension_contexts: {
              'incoming' => {
                'source' => 'puppet:///modules/site_asterisk/extensions/incoming',
              },
              'outgoing' => {
                'source' => 'puppet:///modules/site_asterisk/extensions/outgoing',
              },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_asterisk__extensions('incoming').with_source('puppet:///modules/site_asterisk/extensions/incoming') }
        it { is_expected.to contain_asterisk__extensions('outgoing').with_source('puppet:///modules/site_asterisk/extensions/outgoing') }
      end

      context 'with agents_global parameter set' do
        let(:params) do
          {
            agents_global: {
              'autologoff' => 15,
              'ackcall' => 'yes',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/agents.conf')
            .with_content(%r{^autologoff=15$})
            .with_content(%r{^ackcall=yes$})
        end
      end

      context 'with agents parameter set' do
        let(:params) do
          {
            agents: {
              'joe' => {
                'ext'        => '1001',
                'password'   => sensitive('1234'),
                'agent_name' => 'Joe Bloggs',
              },
              'jane' => {
                'ext'        => '1002',
                'password'   => sensitive('5678'),
                'agent_name' => 'Jane Bloggs',
              },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_asterisk__agent('joe')
            .with(
              ext: '1001',
              password: sensitive('1234'),
              agent_name: 'Joe Bloggs',
            )
        end

        it do
          is_expected.to contain_asterisk__agent('jane')
            .with(
              ext: '1002',
              password: sensitive('5678'),
              agent_name: 'Jane Bloggs',
            )
        end
      end

      context 'with features_general parameter set' do
        let(:params) do
          {
            features_general: {
              'parkext' => '800',
              'parkpos' => '801-820',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/features.conf')
            .with_content(%r{^parkext=800$})
            .with_content(%r{^parkpos=801-820$})
        end
      end

      context 'with features_featuremap parameter set' do
        let(:params) do
          {
            features_featuremap: {
              'blindxfer' => '#1',
              'atxfer'    => '*2',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/features.conf')
            .with_content(%r{^blindxfer => #1$})
            .with_content(%r{^atxfer => \*2$})
        end
      end

      context 'with features_applicationmap parameter set' do
        let(:params) do
          {
            features_applicationmap: {
              'pausemonitor'   => '#1,self/callee,Pausemonitor',
              'unpausemonitor' => '#3,self/callee,UnPauseMonitor',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/features.conf')
            .with_content(%r{^pausemonitor => #1,self/callee,Pausemonitor$})
            .with_content(%r{^unpausemonitor => #3,self/callee,UnPauseMonitor$})
        end
      end

      context 'with features parameter set' do
        let(:params) do
          {
            features: {
              'myfeaturegroup' => {
                'options' => {
                  'pausemonitor' => '#1,self/callee,Pausemonitor',
                },
              },
              'otherfeaturegroup' => {
                'options' => {
                  'unpausemonitor' => '#3,self/callee,UnPauseMonitor',
                },
              },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_asterisk__feature('myfeaturegroup')
            .with_options('pausemonitor' => '#1,self/callee,Pausemonitor')
        end

        it do
          is_expected.to contain_asterisk__feature('otherfeaturegroup')
            .with_options('unpausemonitor' => '#3,self/callee,UnPauseMonitor')
        end
      end

      context 'with logger_general parameter set' do
        let(:params) do
          {
            logger_general: {
              'dateformat' => '%F %T',
              'queue_log'  => 'yes',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/logger.conf')
            .with_content(%r{^dateformat=%F %T$})
            .with_content(%r{^queue_log=yes$})
        end
      end

      context 'with log_files parameter set' do
        let(:params) do
          {
            log_files: {
              'console' => {
                'levels' => %w[notice warning error],
              },
              'messages' => {
                'formatter' => 'json',
                'levels'    => %w[notice warning error],
              },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/logger.conf')
            .with_content(%r{^console => notice,warning,error$})
            .with_content(%r{^messages => \[json\]notice,warning,error$})
        end
      end

      context 'with queues_general parameter set' do
        let(:params) do
          {
            queues_general: {
              'persistentmembers' => 'no',
              'monitor-type'      => 'MixMonitor',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/queues.conf')
            .with_content(%r{^persistentmembers=no$})
            .with_content(%r{^monitor-type=MixMonitor$})
        end
      end

      context 'with queues parameter set' do
        let(:params) do
          {
            queues: {
              'frontline' => {
                'strategy' => 'rrmemory',
                'members'  => ['SIP/reception', 'SIP/secretary'],
              },
              'support' => {
                'strategy' => 'ringall',
                'members'  => ['SIP/agent1', 'SIP/agent2'],
              },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_asterisk__queue('frontline')
            .with(
              strategy: 'rrmemory',
              members: ['SIP/reception', 'SIP/secretary'],
            )
        end

        it do
          is_expected.to contain_asterisk__queue('support')
            .with(
              strategy: 'ringall',
              members: ['SIP/agent1', 'SIP/agent2'],
            )
        end
      end

      context 'with modules_autoload parameter set' do
        let(:params) do
          {
            modules_autoload: false,
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/modules.conf')
            .with_content(%r{^autoload=no$})
        end
      end

      context 'with modules_preload parameter set' do
        let(:params) do
          {
            modules_preload: ['res_odbc.so', 'res_config_odbc.so'],
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/modules.conf')
            .with_content(%r{^preload => res_odbc\.so$})
            .with_content(%r{^preload => res_config_odbc\.so$})
        end
      end

      context 'with modules_noload parameter set' do
        let(:params) do
          {
            modules_noload: ['chan_alsa.so', 'chan_oss.so'],
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/modules.conf')
            .with_content(%r{^noload => chan_alsa\.so$})
            .with_content(%r{^noload => chan_oss\.so$})
        end
      end

      context 'with modules_load parameter set' do
        let(:params) do
          {
            modules_load: ['res_musiconhold.so', 'res_http_media_cache.so'],
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/modules.conf')
            .with_content(%r{^load => res_musiconhold\.so$})
            .with_content(%r{^load => res_http_media_cache\.so$})
        end
      end

      context 'with modules_global parameter set' do
        let(:params) do
          {
            modules_global: {
              'res_odbc.so' => 'myconn',
            },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/modules.conf')
            .with_content(%r{^res_odbc\.so=myconn$})
        end
      end

      context 'with manager_enable parameter set' do
        let(:params) do
          {
            manager_enable: false,
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/manager.conf')
            .with_content(%r{^enabled=false$})
        end
      end

      context 'with manager_port parameter set' do
        let(:params) do
          {
            manager_port: 5039,
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/manager.conf')
            .with_content(%r{^port=5039$})
        end
      end

      context 'with manager_bindaddr parameter set' do
        let(:params) do
          {
            manager_bindaddr: '0.0.0.0',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/asterisk/manager.conf')
            .with_content(%r{^bindaddr=0\.0\.0\.0$})
        end
      end

      context 'with manager_accounts parameter set' do
        let(:params) do
          {
            manager_accounts: {
              'nagios' => {
                'secret' => sensitive('topsecret'),
                'read'   => %w[system call],
                'write'  => %w[system call],
              },
              'admin' => {
                'secret' => sensitive('anothersecret'),
                'read'   => ['all'],
                'write'  => ['all'],
              },
            },
          }
        end

        it do
          is_expected.to contain_asterisk__manager('nagios')
            .with(
              secret: sensitive('topsecret'),
              read: %w[system call],
              write: %w[system call],
            )
        end

        it do
          is_expected.to contain_asterisk__manager('admin')
            .with(
              secret: sensitive('anothersecret'),
              read: ['all'],
              write: ['all'],
            )
        end
      end
    end
  end
end
