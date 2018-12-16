# @summary Configure an asterisk manager
#
# @example manager with default authorizations that can connect from LAN.
#   asterisk::manager { 'sophie':
#     secret => Sensitive.new('youllneverguesswhatitis'),
#     permit => ['192.168.120.0/255.255.255.0'],
#   }
#
# @see https://www.voip-info.org/asterisk-config-managerconf/
#
# @param secret
#   Authentication password for the manager.
# @param ensure
#   Set to `absent` to remove the manager.
# @param manager_name
#   Can be used to override the name of the manager. By default the
#   name of the manager corresponds to `$name`.
# @param deny
#   List of IP specifications that are denied access to the manager.  Denied
#   IPs can be overridden by `$permit`. This makes it possible to only permit
#   access to some IP addresses. Default value is to deny access to everybody.
# @param permit
#   List of IP specifications that are permitted access to the manager.
#   Defaults to premitting only localhost.
# @param read
#   List of authorizations given to the manager to read certain information or
#   configuration. Defaults to `system` and `call`.
# @param write
#   List of authorizations given to the manager to write (change) certain
#   information or configuration. Defaults to `system` and `call`.
#
define asterisk::manager (
  Sensitive[String[1]] $secret,
  $ensure                            = present,
  String[1]            $manager_name = $name,
  Array[String[1]]     $deny         = ['0.0.0.0/0.0.0.0'],
  Array[String[1]]     $permit       = ['127.0.0.1/255.255.255.255'],
  Array[String[1]]     $read         = ['system', 'call'],
  Array[String[1]]     $write        = ['system', 'call']
) {

  asterisk::dotd::file { "manager_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'manager.d',
    content  => template('asterisk/snippet/manager.erb'),
    filename => "${name}.conf",
  }

}
