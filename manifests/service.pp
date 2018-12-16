# Ensure the Asterisk service is running.
#
class asterisk::service {

  assert_private()

  if $asterisk::manage_service {
    service { $asterisk::service_name:
      ensure  => running,
    }
  }

}
