define asterisk::context::iax (
  $ensure  = 'present',
  $source  = false,
  $content = false) {

  if $source {
    asterisk::dotd_file {"${name}.conf":
      ensure  => $ensure,
      dotd_dir => 'iax.conf.d',
      source  => $source,
      notify  => Service['asterisk'],
    }
  } else {
    if $content {
      asterisk::dotd_file {"${name}.conf":
        ensure  => $ensure,
        dotd_dir => 'iax.conf.d',
        content => "[${name}]\n${content}",
        notify  => Service['asterisk'],
      }
    } else {
      fail('source or content parameter is required')
    }
  }
}
