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
