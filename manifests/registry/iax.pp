define asterisk::registry::iax (
  $server,
  $user,
  $password ) {
  require asterisk::iax

  asterisk::dotd_file { "${name}.conf":
    dotd_dir => 'iax.registry.d',
    content => template('asterisk/registry/iax.erb'),
  }
}
