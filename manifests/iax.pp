define asterisk::iax (
  $ensure  = present,
  $source  = false,
  $content = false
) {

  if $source {
    asterisk::dotd::file {"iax_${name}.conf":
      ensure   => $ensure,
      dotd_dir => 'iax.d',
      source   => $source,
      filename => "${name}.conf",
    }
  } else {
    if $content {
      asterisk::dotd::file {"iax_${name}.conf":
        ensure   => $ensure,
        dotd_dir => 'iax.d',
        content  => "[${name}]\n${content}",
        filename => "${name}.conf",
      }
    } else {
      fail('source or content parameter is required')
    }
  }

}
