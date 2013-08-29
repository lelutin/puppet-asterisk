# If you specify $iax_options you lose all default values, so make sure to set
# them in your hash.
class asterisk (
  $iax = $asterisk::params::iax,
  $sip = $asterisk::params::sip,
  $voicemail = $asterisk::params::voicemail,
  $extensions = $asterisk::params::extensions,
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
  if $sip == 'enable'{
    asterisk::config_dotd {'/etc/asterisk/sip.conf':
      additional_paths => ['/etc/asterisk/sip.registry.d'],
    }
  }
  if $iax =='enable'{
    asterisk::config_dotd {'/etc/asterisk/iax.conf':
      additional_paths => ['/etc/asterisk/iax.registry.d'],
      content          => template('asterisk/iax.conf.erb'),
    }
  }
  if $manager == 'enable'{
    asterisk::config_dotd {'/etc/asterisk/manager.conf':}
  }
  if $queues == 'enable' {
    asterisk::config_dotd {'/etc/asterisk/queues.conf':}
  }
  if $extensions == 'enable'{
    asterisk::config_dotd {'/etc/asterisk/extensions.conf':}
  }
  if $voicemail == 'enable'{
    asterisk::config_dotd {'/etc/asterisk/voicemail.conf':}
  }
}

