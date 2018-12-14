# Configure a dialplan context and extensions within that context
#
# $ensure can be set to false to remove the corresponding configuration file.
#
# $source is a puppet file source where the contents of the file can be found.
#
# $content is the textual contents of the file. This option is mutually
#   exclusive with $source.
#
define asterisk::extensions (
  $ensure  = present,
  $source  = false,
  $content = false
) {

  if $source {
    asterisk::dotd::file { "extensions_${name}.conf":
      ensure   => $ensure,
      dotd_dir => 'extensions.d',
      source   => $source,
      filename => "${name}.conf",
    }
  } else {
    if $content {
      asterisk::dotd::file { "extensions_${name}.conf":
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
