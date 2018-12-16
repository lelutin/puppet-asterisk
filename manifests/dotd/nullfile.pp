# @summary Create a file in .d directories to avoid service start issues
#
# The name of the resouce should be the path to create the file in.
#
# This defined type is not intended to be used directly.
#
# @api private
#
define asterisk::dotd::nullfile () {
  assert_private()

  include asterisk::install
  include asterisk::service

  file { "${name}/null.conf":
    ensure  => present,
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
    require => Class['asterisk::install'],
    notify  => Class['asterisk::service'],
  }
}
