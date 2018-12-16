# @summary Configure an IAX2 registry
#
# This makes it possible to register to an IAX2 peer for authenticated
# connections.
#
# @param server
#   Hostname or IP address of the server to which Asterisk should register.
# @param user
#   User name used for authenticating with the distant server.
# @param password
#   Password used for authenticating.
# @param ensure
#   Set to `absent` in order to remove the registry.
#
define asterisk::registry::iax (
  Stdlib::Host         $server,
  String[1]            $user,
  Sensitive[String[1]] $password,
  $ensure = present,
) {

  asterisk::dotd::file { "registry__iax_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'iax.registry.d',
    content  => template('asterisk/registry/iax.erb'),
    filename => "${name}.conf",
  }

}
