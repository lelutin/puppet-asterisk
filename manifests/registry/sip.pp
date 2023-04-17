# @summary Configure a SIP registry
#
# This makes it possible to register to a SIP peer for authenticated
# connections.
#
# @param server
#   Hostname or IP address of the server to which Asterisk should register.
# @param user
#   User id for the local server.
# @param ensure
#   Set to `absent` in order to remove the registry.
# @param password
#   Optional password used for authenticating. This is required if our peer
#   does not match connections only on IP/port.
# @param authuser
#   Optional user name used for authenticating with the remote server. This is
#   required if our peer does not match connections only on IP/port.
# @param port
#   Numerical port with which a connection will be established to the remote
#   server.
# @param extension
#   Extension that is used when calls are received from the remote server. When
#   not set, extension will be 's'.
#
define asterisk::registry::sip (
  Stdlib::Host                   $server,
  String[1]                      $user,
  Stdlib::Ensure::File::File     $ensure    = file,
  Optional[Sensitive[String[1]]] $password  = undef,
  Optional[String[1]]            $authuser  = undef,
  Optional[Integer]              $port      = undef,
  Optional[String[1]]            $extension = undef
) {
  if $password =~ Undef and $authuser !~ Undef {
    fail('authuser was specified but no value was given for password. You need both to authenticate.')
  }

  $sip_variables = {
    user      => $user,
    password  => $password,
    authuser  => $authuser,
    server    => $server,
    port      => $port,
    extension => $extension,
  }
  asterisk::dotd::file { "registry__sip_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'sip.registry.d',
    content  => epp('asterisk/registry/sip.epp', $sip_variables),
    filename => "${name}.conf",
  }
}
