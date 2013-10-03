class asterisk::config {

  shellvar {'RUNASTERISK':
    ensure  => present,
    target  => '/etc/default/asterisk',
    value   => 'yes',
    require => Package['asterisk'],
    notify  => Service['asterisk'],
  }

}
