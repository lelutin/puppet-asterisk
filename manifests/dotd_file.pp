define asterisk::dotd_file (
  $dotd_dir,
  $content,
  $ensure = 'present',
  $filename = '') {

  $conffile = $filename ? {
    '' => $name,
    default => $filename,
  }

  file {"/etc/asterisk/${dotd_dir}/${conffile}":
    ensure  => $ensure,
    content => $content,
    notify  => Exec['asterisk-reload'],
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
    require => File["/etc/asterisk/${dotd_dir}"],
  }
}
