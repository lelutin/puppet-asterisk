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

  asterisk::dotd::file { "extensions_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'extensions.d',
    source   => $source,
    content  => $real_content,
    filename => "${name}.conf",
  }

}
