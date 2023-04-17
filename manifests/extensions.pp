# @summary Configure a dialplan context and extensions within that context
#
# This can be used to configure your different contexts with extensions, but it
# can also be used to create macros that can be called in other contexts.
#
# @example basic context with one extension
#   asterisk::extensions { 'basic':
#     content => 'exten => 666,1,Hangup()',
#   }
#
# @see https://www.voip-info.org/asterisk-config-extensionsconf/
# @see http://asteriskdocs.org/en/3rd_Edition/asterisk-book-html-chunk/asterisk-DP-Basics.html
#
# @param ensure
#   Set this to false to remove the corresponding configuration file.
# @param source
#   Puppet file source where the contents of the file can be found.
# @param content
#   Textual contents of the file. This option is mutually exclusive with
#   `$source`.
#
define asterisk::extensions (
  Stdlib::Ensure::File::File   $ensure  = file,
  Optional[Stdlib::Filesource] $source  = undef,
  # Only enforcing type for this param since we're using its value
  Optional[String]             $content = undef,
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
