# Create a file inside a .d directory and set its permissions correctly.
#
# $dotd_dir is the path of the .d directory in which the file should be created.
#
# $ensure can be set to absent to remove the file
#
# $source is a puppet file source where the contents can be found.
#
# $content is the textual contents of the file. This option is mutually
#   exclusive with $source.
#
# $filename if defined, sets the name of the file created. Otherwise, $name is
#   used as the file name.
#
define asterisk::dotd::file (
  $dotd_dir,
  $ensure = present,
  $source = '',
  $content = '',
  $filename = ''
) {
  include asterisk::config
  include asterisk::service

  if ($source == '') and ($content == '') {
    fail('You must supply a value for either one of $source or $content.')
  }
  if ($source != '') and ($content != '') {
    fail('Please provide either a $source or a $content, but not both.')
  }

  $conffile = $filename ? {
    ''      => $name,
    default => $filename,
  }

  file {"/etc/asterisk/${dotd_dir}/${conffile}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
    require => Class['asterisk::config'],
    notify  => Class['asterisk::service'],
  }

  if $content != '' {
    File["/etc/asterisk/${dotd_dir}/${conffile}"] {
      content => $content,
    }
  } else {
    File["/etc/asterisk/${dotd_dir}/${conffile}"] {
      source => $source,
    }
  }
}
