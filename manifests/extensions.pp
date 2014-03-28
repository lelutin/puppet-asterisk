define asterisk::extensions (
  $ensure  = present,
  $source  = false,
  $content = false
) {

  if $source {
    asterisk::dotd::file {"extensions_${name}.conf":
      ensure   => $ensure,
      dotd_dir => 'extensions.d',
      source   => $source,
      filename => "${name}.conf",
    }
  } else {
    if $content {
      asterisk::dotd::file {"extensions_${name}.conf":
        ensure   => $ensure,
        dotd_dir => 'extensions.d',
        content  => "[${name}]\n${content}",
        filename => "${name}.conf",
      }
    } else {
      fail('source or content parameter is required')
    }
  }

}
