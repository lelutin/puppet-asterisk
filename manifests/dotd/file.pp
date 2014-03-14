# create include files and set their permissions.
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
