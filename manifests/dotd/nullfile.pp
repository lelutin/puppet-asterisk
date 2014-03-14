# This is a hack to make it possible to iterate over multiple directories.
define asterisk::dotd::nullfile () {
  include asterisk::install
  include asterisk::service

  file {"${name}/null.conf":
    ensure  => present,
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
    require => Class['asterisk::install'],
    notify  => Class['asterisk::service'],
  }
}
