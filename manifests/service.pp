# class managing if service is running
class asterisk::service (
  $manage_service = $asterisk::params::manage_service,
) inherits asterisk::params{

  if ( $manage_service == 'true' ) or ( $manage_service == 'auto') {
    service {'asterisk':
      ensure  => running,
      require => Package['asterisk'],
    }
  } else {
    service {'asterisk':
      enable  => 'false',
      require => Package['asterisk'],
    }
  
  }

}
