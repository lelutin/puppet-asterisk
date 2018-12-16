# @summary Requirements for the asterisk dahdi module to work
#
# DAHDI (Digium/Asterisk Hardware Device Interface) lets you connect your
# Asterisk PBX to a card, Digium and some other models, that bridges calls with
# the POTS.
#
# @todo This class is possibly incomplete and it needs to be finished and tested.
#
class asterisk::dahdi {

  package { [
    'asterisk-dahdi',
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
