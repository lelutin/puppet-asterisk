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
  Stdlib::Host               $server,
  String[1]                  $user,
  Sensitive[String[1]]       $password,
  Stdlib::Ensure::File::File $ensure = file,
) {
  $iax_variables = {
    user     => $user,
    password => $password,
    server   => $server,
  }
  asterisk::dotd::file { "registry__iax_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'iax.registry.d',
    content  => epp('asterisk/registry/iax.epp', $iax_variables),
    filename => "${name}.conf",
  }
}
