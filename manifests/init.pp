class asterisk {
  package {
    ['asterisk',
    'asterisk-sounds-extra',
    'asterisk-dev',
    'asterisk-sounds-main',
    'asterisk-doc']:
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

#  file {"/etc/default/asterisk":
#    source => "puppet:///asterisk/asterisk.default",
#    require => Package["asterisk"],
#  }

  # Configuration directories
  asterisk::config_dotd {'/etc/asterisk/sip.conf':
    additional_paths => ['/etc/asterisk/sip.registry.d'],
  }
  asterisk::config_dotd {'/etc/asterisk/iax.conf':
    additional_paths => ['/etc/asterisk/iax.registry.d'],
  }
  asterisk::config_dotd {'/etc/asterisk/manager.conf':}
  asterisk::config_dotd {'/etc/asterisk/queues.conf':}
  asterisk::config_dotd {'/etc/asterisk/extensions.conf':}
  asterisk::config_dotd {'/etc/asterisk/voicemail.conf':}
}

