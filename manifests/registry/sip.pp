define asterisk::registry::sip (
  $server,
  $user,
  $ensure    = present,
  $password  = '',
  $authuser  = '',
  $port      = '',
  $extension = ''
) {

  if $password == '' and $authuser != '' {
    fail('No value given for password: supplying a value for $authuser only makes sense when $password is set.')
  }

  asterisk::dotd::file { "registry__sip_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'sip.registry.d',
    content  => template('asterisk/registry/sip.erb'),
    filename => "${name}.conf",
  }

}
