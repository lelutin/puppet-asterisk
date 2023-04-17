# @summary Ensure the Asterisk service is running.
#
# This class is not intended to be used directly.
#
# @api private
#
class asterisk::service {
  assert_private()

  if $asterisk::manage_service {
    service { $asterisk::service_name:
      ensure  => running,
    }
  }
}
