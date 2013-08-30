define asterisk::registry::sip (
  $server,
  $user,
  $password='',
  $authuser='',
  $port='',
  $extension='' ) {
  require asterisk::sip

  if $password == '' and $authuser != '' {
    fail('No value given for password: supplying a value for $authuser only makes sense when $password is set.')
  }

  asterisk::dotd_file { "${name}.conf":
    dotd_dir => 'sip.registry.d',
    content => template('asterisk/registry/sip.erb'),
  }
}
