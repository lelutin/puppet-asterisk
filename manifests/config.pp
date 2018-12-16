# @summary asterisk basic configuration files.
#
# This class is not intended to be used directly.
#
# @api private
#
class asterisk::config {

  assert_private()

  case $facts['os']['family'] {
    'RedHat': {
      $service_settings_path = "/etc/sysconfig/${asterisk::service_name}"
    }
    'Debian': {
      $service_settings_path = "/etc/default/${asterisk::service_name}"
    }
    default: {
      fail("Unsupported system '${facts['os']['name']}'.")
    }
  }

  augeas { 'run_asterisk':
    changes => [
      "set /files/${service_settings_path}/RUNASTERISK yes",
    ],
  }

  $iax_general = $asterisk::real_iax_general
  asterisk::dotd { '/etc/asterisk/iax':
    additional_paths => ['/etc/asterisk/iax.registry.d'],
    content          => template('asterisk/iax.conf.erb'),
  }

  $sip_general = $asterisk::real_sip_general
  asterisk::dotd { '/etc/asterisk/sip':
    additional_paths => ['/etc/asterisk/sip.registry.d'],
    content          => template('asterisk/sip.conf.erb'),
  }

  $voicemail_general = $asterisk::real_voicemail_general
  asterisk::dotd { '/etc/asterisk/voicemail':
    content => template('asterisk/voicemail.conf.erb'),
  }

  $extensions_general = $asterisk::real_extensions_general
  asterisk::dotd { '/etc/asterisk/extensions':
    content => template('asterisk/extensions.conf.erb'),
  }

  $agents_multiplelogin = $asterisk::real_agents_multiplelogin
  asterisk::dotd { '/etc/asterisk/agents':
    content => template('asterisk/agents.conf.erb'),
  }

  $features_general = $asterisk::real_features_general
  asterisk::dotd { '/etc/asterisk/features':
    content          => template('asterisk/features.conf.erb'),
  }

  $queues_general = $asterisk::real_queues_general
  asterisk::dotd { '/etc/asterisk/queues':
    content => template('asterisk/queues.conf.erb'),
  }

  $manager_enable = $asterisk::real_manager_enable
  $manager_port = $asterisk::manager_port
  $manager_bindaddr = $asterisk::manager_bindaddr
  asterisk::dotd { '/etc/asterisk/manager':
    content => template('asterisk/manager.conf.erb'),
  }

  $modules_autoload = $asterisk::real_modules_autoload
  file { '/etc/asterisk/modules.conf' :
    ensure  => present,
    content => template('asterisk/modules.conf.erb'),
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
  }

}
