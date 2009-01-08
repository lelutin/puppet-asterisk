define asterisk::context (
  $ensure  = 'present',
  $source  = false,
  $content = false) {

  if $source {
    file {"/etc/asterisk/extensions.conf.d/${name}.conf":
      ensure  => $ensure,
      source  => $source,
      require => File["/etc/asterisk/extensions.conf.d"],
      notify  => Exec["asterisk-reload"],
    }
  } else {
    if $content {
      file {"/etc/asterisk/extensions.conf.d/${name}.conf":
        ensure  => $ensure,
        content => "[${name}]\n${content}",
        require => File["/etc/asterisk/extensions.conf.d"],
        notify  => Exec["asterisk-reload"],
      }
    } else {
      fail "source or content parameter is required"
    }
  }
}
