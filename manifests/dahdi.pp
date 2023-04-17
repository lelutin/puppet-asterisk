# @summary Requirements for the asterisk dahdi module to work
#
# DAHDI (Digium/Asterisk Hardware Device Interface) lets you connect your
# Asterisk PBX to a card, Digium and some other models, that bridges calls with
# the POTS.
#
# @see https://wiki.asterisk.org/wiki/display/DAHDI/DAHDI
#
# @see https://wiki.asterisk.org/wiki/display/AST/chan_dahdi+Channel+Variables
#
# @todo This class could be merged into config.pp and used conditionally to a
#   boolean parameter that enables/disables (off by default) dahdi.
#
# @todo The module would also need to template out chan_dahdi.conf -- changes
#   to that file need to trigger a full restart of asterisk, not just a reload.
#
class asterisk::dahdi {
  package { [
      'asterisk-dahdi',
      'dahdi',
      'dahdi-dkms', # dahdi autokompile ubuntu
      'dahdi-linux', # dahdi linux kernel module
      'dahdi-source', # dahdi sources
    ]:
      ensure => installed,
  }

#  User['asterisk'] {
#    groups => 'dialout',
#  }
}
