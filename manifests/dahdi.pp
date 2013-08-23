class asterisk::dahdi inherits asterisk {

  package {
    ['asterisk-dahdi',
    'dahdi',
    'dahdi-dkms', # dahdi autokompile ubuntu
    'dahdi-linux', # dahdi linux kernel module
    'dahdi-source', # dahdi sources
    ]:
    ensure => installed
  }

  User['asterisk'] {
    groups => 'dialout',
  }
}
