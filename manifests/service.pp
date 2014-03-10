# class managing if service is running
class asterisk::service {
  $manage_service = $asterisk::manage_service

  if $manage_service {
    service {$asterisk::service_name:
      ensure  => running,
    }
  } else {
    service {$asterisk::service_name:
      enable  => false,
    }

  }

}
