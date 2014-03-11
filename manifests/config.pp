class asterisk::config {

  case $::operatingsystem {
    'CentOS', 'Fedora', 'Scientific', 'RedHat', 'Amazon', 'OracleLinux': {
      $service_settings_path = "/etc/sysconfig/${asterisk::service_name}"
    }
    'Debian', 'Ubuntu': {
      $service_settings_path = "/etc/default/${asterisk::service_name}"
    }
    default: {
      fail("Unsupported system '${::operatingsystem}'.")
    }
  }

  shellvar {'RUNASTERISK':
    ensure  => present,
    target  => $service_settings_path,
    value   => 'yes',
  }

  asterisk::config_dotd {'/etc/asterisk/extensions.conf':}
  asterisk::config_dotd {'/etc/asterisk/voicemail.conf':}
  asterisk::config_dotd {'/etc/asterisk/queues.conf':}
  asterisk::config_dotd {'/etc/asterisk/manager.conf':}

  $iax_options = $asterisk::real_iax_options

  asterisk::config_dotd {'/etc/asterisk/iax.conf':
    additional_paths => ['/etc/asterisk/iax.registry.d'],
    content          => template('asterisk/iax.conf.erb'),
  }

  $sip_options = $asterisk::real_sip_options

  validate_array($sip_options['allow'])
  validate_array($sip_options['disallow'])
  validate_array($sip_options['domain'])
  validate_array($sip_options['localnet'])

  asterisk::config_dotd {'/etc/asterisk/sip.conf':
    additional_paths => ['/etc/asterisk/sip.registry.d'],
    content          => template('asterisk/sip.conf.erb'),
  }

}
