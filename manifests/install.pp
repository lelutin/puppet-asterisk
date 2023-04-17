# @summary Install packages that are necessary for an asterisk server.
#
# This class is not intended to be used directly.
#
# @api private
#
class asterisk::install {
  assert_private()

  if $asterisk::manage_package {
    package { $asterisk::package_name:
      ensure => installed,
    }
  }
}
