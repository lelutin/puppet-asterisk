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
  $secret,
  $ensure       = present,
  $manager_name = false,
  $deny         = ['0.0.0.0/0.0.0.0'],
  $permit       = ['127.0.0.1/255.255.255.255'],
  $read         = ['system', 'call'],
  $write        = ['system', 'call']
) {

  validate_string($secret)
  validate_array($deny)
  validate_array($permit)
  validate_array($read)
  validate_array($write)

  $real_manager_name = $manager_name ? {
    false   => $name,
    default => $manager_name
  }
  validate_string($real_manager_name)

  $real_read = join($read, ',')
  $real_write = join($write, ',')

  asterisk::dotd::file {"manager_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'manager.d',
    content  => template('asterisk/snippet/manager.erb'),
    filename => "${name}.conf",
  }

}
