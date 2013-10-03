class asterisk::service {

  service {'asterisk':
    ensure  => running,
    require => Package['asterisk'],
  }

}
