# This class install default configuration files for Asterisk

class asterisk::defaults {
  asterisk::context {"macro-dial-external":
    ensure => present,
    source => "puppet:///asterisk/macro-dial-external.conf",
  }
}
