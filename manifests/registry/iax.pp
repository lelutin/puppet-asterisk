define asterisk::registry::iax (
  $server,
  $user,
  $password,
  $ensure = present,
) {

  asterisk::dotd::file { "${name}.conf":
    ensute   => $ensure,
    dotd_dir => 'iax.registry.d',
    content  => template('asterisk/registry/iax.erb'),
  }

}
