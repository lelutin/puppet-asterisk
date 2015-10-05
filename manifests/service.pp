# Ensure the Asterisk service is running.
#
# FIXME: why are we disabling the service when $manage_service is set to false?
# this does not make any sense.
#
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
