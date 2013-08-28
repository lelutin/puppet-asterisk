# If you specify $iax_options you lose all default values, so make sure to set
# them in your hash.
class asterisk (
  $iax = $asterisk::params::iax,
  $sip = $asterisk::params::sip,
  $voicemail = $asterisk::params::voicemail,
  $extentions = $asterisk::params::extentions,
  $queues = $asterisk::params::queues,
  $manager = $asterisk::params::manager,
  $iax_options = $asterisk::params::iax_options,
) inherits asterisk::params {
  package {
    [$package,
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

  # Configuration directories
  if $sip {
    asterisk::config_dotd {'/etc/asterisk/sip.conf':
      additional_paths => ['/etc/asterisk/sip.registry.d'],
    }
  }
  if $iax {
    asterisk::config_dotd {'/etc/asterisk/iax.conf':
      additional_paths => ['/etc/asterisk/iax.registry.d'],
      content          => template('asterisk/iax.conf.erb'),
    }
  }
  if $manager {
    asterisk::config_dotd {'/etc/asterisk/manager.conf':}
  }
  if $queues {
    asterisk::config_dotd {'/etc/asterisk/queues.conf':}
  }
  if $extensions {
    asterisk::config_dotd {'/etc/asterisk/extensions.conf':}
  }
  if $voicemail {
    asterisk::config_dotd {'/etc/asterisk/voicemail.conf':}
  }
}

