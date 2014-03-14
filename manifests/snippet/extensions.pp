define asterisk::snippet::extensions (
  $ensure  = present,
  $source  = false,
  $content = false
) {

  if $source {
    asterisk::dotd::file {"${name}.conf":
      ensure   => $ensure,
      dotd_dir => 'extensions.d',
      source   => $source,
    }
  } else {
    if $content {
      asterisk::dotd::file {"${name}.conf":
        ensure   => $ensure,
        dotd_dir => 'extensions.d',
        content  => "[${name}]\n${content}",
      }
    } else {
      fail('source or content parameter is required')
    }
  }

}
