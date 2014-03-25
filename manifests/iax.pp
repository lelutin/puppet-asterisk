define asterisk::iax (
  $ensure  = present,
  $source  = false,
  $content = false
) {

  if $source {
    asterisk::dotd::file {"${name}.conf":
      ensure   => $ensure,
      dotd_dir => 'iax.d',
      source   => $source,
    }
  } else {
    if $content {
      asterisk::dotd::file {"${name}.conf":
        ensure   => $ensure,
        dotd_dir => 'iax.d',
        content  => "[${name}]\n${content}",
      }
    } else {
      fail('source or content parameter is required')
    }
  }

}
