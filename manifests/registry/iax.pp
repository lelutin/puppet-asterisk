# Configure an IAX2 registry
#
# $server is the hostname or IP of the server to which Asterisk should register.
#
# $user is the user name used for registering with the distant server.
#
# $password is the password used for registering.
#
# $ensure can be set to absent in order to remove the registry
#
define asterisk::registry::iax (
  $server,
  $user,
  $password,
  $ensure = present,
) {

  asterisk::dotd::file { "registry__iax_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'iax.registry.d',
    content  => template('asterisk/registry/iax.erb'),
    filename => "${name}.conf",
  }

}
