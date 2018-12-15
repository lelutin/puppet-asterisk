# Configure a SIP registry
#
# $server is the hostname or IP of the server to which Asterisk should register.
#
# $user is the user id for the local server
#
# $ensure can be set to absent in order to remove the registry
#
# $password is the optional password used for registering.
#
# $authuser is the optional user name used for authenticating with the remote
#   server.
#
# $port is a string representing the numerical port with which a connection
#   will be established to the remote server.
#
# $extension is the extension that is used when calls are received from the
#   remote server. When not set, extension will be 's'.
#
define asterisk::registry::sip (
  String[1]                      $server,
  String[1]                      $user,
  $ensure                                   = present,
  Optional[Sensitive[String[1]]] $password  = undef,
  Optional[String[1]]            $authuser  = undef,
  Optional[String[1]]            $port      = undef,
  Optional[String[1]]            $extension = undef
) {

  if $password =~ Undef and $authuser !~ Undef {
    fail('No value given for password: supplying a value for $authuser only makes sense when $password is set.')
  }

  asterisk::dotd::file { "registry__sip_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'sip.registry.d',
    content  => template('asterisk/registry/sip.erb'),
    filename => "${name}.conf",
  }

}
