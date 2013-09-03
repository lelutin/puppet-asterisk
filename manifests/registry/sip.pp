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

  file_line{ 'include /etc/asterisk/sip.registry.d/*':
      path => '/etc/asterisk/sip.conf',
      line => "#include </etc/asterisk/sip.registry.d/*.conf>",
  }

  asterisk::dotd_file { "${name}.conf":
    dotd_dir => 'sip.registry.d',
    content => template('asterisk/registry/sip.erb'),
  }
}
