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

  asterisk::config_dotd { '/etc/asterisk/queues': }

  $iax_options = $asterisk::real_iax_options
  asterisk::config_dotd { '/etc/asterisk/iax':
    additional_paths => ['/etc/asterisk/iax.registry.d'],
    content          => template('asterisk/iax.conf.erb'),
  }

  $sip_options = $asterisk::real_sip_options
  asterisk::config_dotd { '/etc/asterisk/sip':
    additional_paths => ['/etc/asterisk/sip.registry.d'],
    content          => template('asterisk/sip.conf.erb'),
  }

  $voicemail_options = $asterisk::real_voicemail_options
  asterisk::config_dotd { '/etc/asterisk/voicemail':
    content => template('asterisk/voicemail.conf.erb'),
  }

  $extensions_options = $asterisk::real_extensions_options
  asterisk::config_dotd { '/etc/asterisk/extensions':
    content => template('asterisk/extensions.conf.erb'),
  }

  $manager_enable = $asterisk::real_manager_enable
  $manager_port = $asterisk::manager_port
  $manager_bindaddr = $asterisk::manager_bindaddr
  asterisk::config_dotd { '/etc/asterisk/manager':
    content => template('asterisk/manager.conf.erb'),
  }

  $modules_autoload = $asterisk::real_modules_autoload
  $modules_noload = $asterisk::modules_noload
  $modules_load = $asterisk::modules_load
  $modules_global_options = $asterisk::modules_global_options
  file { '/etc/asterisk/modules.conf' :
    ensure  => present,
    content => template('asterisk/modules.conf.erb'),
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
  }

}
