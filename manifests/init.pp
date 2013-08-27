# If you specify $iax_options you lose all default values, so make sure to set
# them in your hash.
class asterisk (
  $iax_options = {
    disallow => ['lpc10'],
    allow => ['gsm'],
    delayreject => 'yes',
    bandwidth => 'high',
    jitterbuffer => 'yes',
    forcejitterbuffer => 'yes',
    maxjitterbuffer => '1000',
    maxjitterinterps => '10',
    resyncthreshold => '1000',
    trunktimestamps => 'yes',
    autokill => 'yes',
  } )
{
  package {
    ['asterisk',
    'asterisk-core-sounds-en-alaw',
    'asterisk-core-sounds-en-gsm']:
    ensure => installed,
  }

  service {'asterisk':
    ensure  => running,
    require => [Package['asterisk'], User['asterisk'], Group['asterisk']],
  }

  exec {'asterisk-reload':
    command     => '/etc/init.d/asterisk reload',
    refreshonly => true,
  }

  user {'asterisk':
    ensure   => present,
    require  => Package['asterisk'],
  }

  group {'asterisk':
    ensure   => present,
    require  => Package['asterisk'],
  }

  line {'remove RUNASTERISK=no':
    ensure => absent,
    file => '/etc/default/asterisk',
    line => 'RUNASTERISK=no',
    require => Package['asterisk'],
  }

  line {'asterisk on boot YES':
    file => '/etc/default/asterisk',
    line => 'RUNASTERISK=yes',
    require => [Package['asterisk'], Line['remove RUNASTERISK=no']],
    notify => Exec['asterisk-reload'],
  }

  # Configuration directories
  asterisk::config_dotd {'/etc/asterisk/sip.conf':
    additional_paths => ['/etc/asterisk/sip.registry.d'],
  }
  asterisk::config_dotd {'/etc/asterisk/iax.conf':
    additional_paths => ['/etc/asterisk/iax.registry.d'],
    content => template('asterisk/iax.conf.erb'),
  }
  asterisk::config_dotd {'/etc/asterisk/manager.conf':}
  asterisk::config_dotd {'/etc/asterisk/queues.conf':}
  asterisk::config_dotd {'/etc/asterisk/extensions.conf':}
  asterisk::config_dotd {'/etc/asterisk/voicemail.conf':}
}

