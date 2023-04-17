# @summary Configure an IAX2 context and its options
#
# A context named after `$name` will be created. You can configure iax2 users,
# peers or the special context `callnumberlimits` that lets you override limits
# to call numbers per IP address range.
#
# @see https://www.voip-info.org/asterisk-config-iaxconf/
#
# @todo list all options as parameters instead of using textual contents
#
# @param ensure
#   Set this to `absent` to remove the configuration file.
# @param source
#   Puppet file source where the contents of the file can be found.
# @param content
#   Textual contents of the file being created. This option is mutually
#   exclusive with `$source`. The content is placed after the name of the
#   context (which is `$name`) and so it should not include the context name
#   definition.
#
define asterisk::iax (
  Stdlib::Ensure::File::File   $ensure  = file,
  Optional[Stdlib::Filesource] $source  = undef,
  # Only enforcing type for this param since we're using its value
  Optional[String]             $content = undef
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
