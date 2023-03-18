# @summary asterisk basic configuration files.
#
# This class is not intended to be used directly.
#
# @api private
#
class asterisk::config {

  assert_private()

  $iax_general = $asterisk::iax_general
  asterisk::dotd { '/etc/asterisk/iax':
    additional_paths => ['/etc/asterisk/iax.registry.d'],
    content          => template('asterisk/iax.conf.erb'),
  }

  $sip_general = $asterisk::sip_general
  asterisk::dotd { '/etc/asterisk/sip':
    additional_paths => ['/etc/asterisk/sip.registry.d'],
    content          => template('asterisk/sip.conf.erb'),
  }

  $voicemail_general = $asterisk::voicemail_general
  asterisk::dotd { '/etc/asterisk/voicemail':
    content => template('asterisk/voicemail.conf.erb'),
  }

  $ext_context = {
    general => $asterisk::extensions_general,
    globals => $asterisk::extensions_globals,
  }
  asterisk::dotd { '/etc/asterisk/extensions':
    content => epp('asterisk/extensions.conf.epp', $ext_context),
  }

  $agents_multiplelogin = bool2str($asterisk::agents_multiplelogin, 'yes', 'no')
  asterisk::dotd { '/etc/asterisk/agents':
    content => template('asterisk/agents.conf.erb'),
  }

  $features_general = $asterisk::features_general
  asterisk::dotd { '/etc/asterisk/features':
    content          => template('asterisk/features.conf.erb'),
  }

  $queues_general = $asterisk::queues_general
  asterisk::dotd { '/etc/asterisk/queues':
    content => template('asterisk/queues.conf.erb'),
  }

  $logger_general = $asterisk::logger_general
  $log_files = $asterisk::log_files
  file { '/etc/asterisk/logger.conf' :
    ensure  => present,
    content => template('asterisk/logger.conf.erb'),
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
  }

  $manager_enable = bool2str($asterisk::manager_enable, 'yes', 'no')
  $manager_port = $asterisk::manager_port
  $manager_bindaddr = $asterisk::manager_bindaddr
  asterisk::dotd { '/etc/asterisk/manager':
    content => template('asterisk/manager.conf.erb'),
  }

  $modules_autoload = bool2str($asterisk::modules_autoload, 'yes', 'no')
  file { '/etc/asterisk/modules.conf' :
    ensure  => present,
    content => template('asterisk/modules.conf.erb'),
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
  }

}
