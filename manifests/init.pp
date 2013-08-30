# If you specify $iax_options you lose all default values, so make sure to set
# them in your hash.
class asterisk {
  package {
    [$asterisk::params::package,
    'asterisk-core-sounds-en-alaw',
    'asterisk-core-sounds-en-gsm']:
    ensure => installed,
  }

  service {'asterisk':
    ensure  => running,
    require => Package['asterisk'],
  }

  shellvar {'RUNASTERISK':
    ensure  => present,
    target  => '/etc/default/asterisk',
    value   => 'yes',
    require => Package['asterisk'],
    notify  => Service['asterisk'],
  }
}

