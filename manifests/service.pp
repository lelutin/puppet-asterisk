# Ensure the Asterisk service is running.
#
class asterisk::service {

  if $asterisk::manage_service {
    service { $asterisk::service_name:
      ensure  => running,
    }
  }

}
