# This is a hack to make array concatenation possible on directories + filename
define asterisk::config_dotd::nullfile () {

  file {"${name}/null.conf":
    ensure  => present,
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
    require => [Package['asterisk'], Group['asterisk'], File[$name]],
  }
}
