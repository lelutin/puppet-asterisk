# This class install default configuration files for Asterisk

class asterisk::defaults {
  asterisk::context {"macro-dial-external":
    ensure => present,
    source => "puppet:///asterisk/macro-dial-external.conf",
  }

  package {"tmpreaper":
    ensure => present,
  }

  cron { "remove call records older than 3 months":
    command => "/usr/sbin/tmpreaper 90d /var/spool/asterisk/monitor",
    user    => "root",
    hour    => 3,
    minute  => 0,
    require => Package["tmpreaper"],
  }
}
