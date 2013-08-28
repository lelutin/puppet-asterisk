# This is a hack to make it possible to iterate over multiple directories.
define asterisk::config_dotd::nullfile () {

  file {"${name}/null.conf":
    ensure  => present,
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
    require => Package['asterisk'],
    notify  => Service['asterisk'],
  }
}
