# This class describes requirements for the asterisk dahdi module to work
class asterisk::dahdi {

  package {
    ['asterisk-dahdi',
    'dahdi',
    'dahdi-dkms', # dahdi autokompile ubuntu
    'dahdi-linux', # dahdi linux kernel module
    'dahdi-source', # dahdi sources
    ]:
    ensure => installed
  }

#  User['asterisk'] {
#    groups => 'dialout',
#  }
}
