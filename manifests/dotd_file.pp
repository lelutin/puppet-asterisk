# create include files and set thair permissions.
define asterisk::dotd_file (
  $dotd_dir,
  $source = '',
  $content = '',
  $ensure = 'present',
  $filename = '') {

  if ($source == '') and ($content == '') {
    fail('You must supply a value for either one of $source or $content.')
  }
  if ($source != '') and ($content != '') {
    fail('Please provide either a $source or a $content, but not both.')
  }

  $conffile = $filename ? {
    '' => $name,
    default => $filename,
  }

  file {"/etc/asterisk/${dotd_dir}/${conffile}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
    require => File["/etc/asterisk/${dotd_dir}"],
    notify  => Service['asterisk'],
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
