# @summary Create a file inside a .d directory and set its permissions correctly.
#
# This defined type is not intended to be used directly.
#
# @api private
#
# @param dotd_dir
#   Path of the .d directory, relative to asterisk's configuration directory,
#   in which the file should be created.
# @param ensure
#   Set to `absent` to remove the file
# @param source
#   Puppet file source where the contents can be found.
# @param content
#   Textual contents of the file. This option is mutually exclusive with
#   `$source`.
# @param filename
#   Can be used to override the name of the file created. Otherwise, `$name` is
#   used as the file name.
#
define asterisk::dotd::file (
  String                       $dotd_dir,
  Stdlib::Ensure::File::File   $ensure   = file,
  Optional[String]             $content  = undef,
  Optional[Stdlib::Filesource] $source   = undef,
  String                       $filename = $name,
) {
  assert_private()

  include asterisk::config
  include asterisk::service

  $nb_set = count([$content, $source])
  if $nb_set == 0 {
    fail('One of $content or $source need to be defined, none were set')
  }
  if $nb_set == 2 {
    fail('Please provide either a $source or a $content, but not both.')
  }

  file { "/etc/asterisk/${dotd_dir}/${filename}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
    require => Class['asterisk::config'],
    notify  => Class['asterisk::service'],
  }

  if $content =~ String {
    File["/etc/asterisk/${dotd_dir}/${filename}"] {
      content => $content,
    }
  } else {
    File["/etc/asterisk/${dotd_dir}/${filename}"] {
      source => $source,
    }
  }
}
