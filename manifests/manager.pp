# Configure and asterisk manager
#
# $secret is the authentication password.
#
# $ensure can be set to absent to remove the manager.
#
# $manager_name can be used to override the name of the manager. By default the
#   name of the manager corresponds to $name.
#
# $deny is a list of IP specifications that are denied access to the manager.
#   Denied IPs can be overridden by $permit. This makes it possible to only
#   permit access to some IP addresses. Default value is to deny access to
#   everybody.
#
# $permit is a list of IP specifications that are permitted access to the
#   manager.
#
# $read is a list of authorizations given to the manager to read certain
#   information or configuration.
#
# $write is a list of authorizations given to the manager to write (change)
#   certain information or configuration.
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

  $real_read = join($read, ',')
  $real_write = join($write, ',')

  asterisk::dotd::file { "manager_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'manager.d',
    content  => template('asterisk/snippet/manager.erb'),
    filename => "${name}.conf",
  }

}
