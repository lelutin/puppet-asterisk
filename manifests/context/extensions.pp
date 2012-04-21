define asterisk::context::extensions (
  $ensure  = 'present',
  $source  = false,
  $content = false) {

  if $source {
    asterisk::dotd_file {"${name}.conf":
      ensure  => $ensure,
      dotd_dir => 'extensions.conf.d',
      source  => $source,
      notify  => Exec['asterisk-reload'],
    }
  } else {
    if $content {
      asterisk::dotd_file {"${name}.conf":
        ensure  => $ensure,
        dotd_dir => 'extensions.conf.d',
        content => "[${name}]\n${content}",
        notify  => Exec['asterisk-reload'],
      }
    } else {
      fail('source or content parameter is required')
    }
  }
}
