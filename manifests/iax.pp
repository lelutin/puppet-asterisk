# Configure an IAX2 context and its options
#
# $ensure can be set to absent to remove the configuration file.
#
# $source is a puppet file source where the contents of the file can be found.
#
# $content is the textual contents of the file being created. This option is
# mutually exclusive with $source. The content is placed after the name of the
# context (which is $name) and so it should not include the context name
# definition.
#
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
