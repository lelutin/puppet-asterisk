# class managing if service is running
class asterisk::service {
  $manage_service = $asterisk::manage_service

  if $manage_service {
    service {'asterisk':
      ensure  => running,
      require => Package['asterisk'],
    }
  } else {
    service {'asterisk':
      enable  => false,
      require => Package['asterisk'],
    }

  }

}
