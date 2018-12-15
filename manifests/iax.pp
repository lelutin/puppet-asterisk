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
  $source  = undef,
  # Only enforcing type for this param since we're using its value
  Optional[String] $content = undef
) {

  if $content !~ Undef {
    $real_content = "[${name}]\n${content}"
  }
  else {
    $real_content = $content
  }

  asterisk::dotd::file { "iax_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'iax.d',
    source   => $source,
    content  => $real_content,
    filename => "${name}.conf",
  }

}
