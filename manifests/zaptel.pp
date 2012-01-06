class asterisk::zaptel inherits asterisk {
  package {
    ["zaptel",
    "zaptel-source",
    "libfile-sync-perl", # asterisk-app-fax dep
    "libmime-lite-perl", # asterisk-app-fax dep
    "libconfig-tiny-perl", # asterisk-app-fax dep
    ]:
    ensure => installed
  }

  # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=491923
  case $lsbdistcodename {
    'etch': {
      package {
        ["asterisk-app-fax",
        "asterisk-bristuff"]:
        ensure => present
      }
    }
  }

  exec {"m-a-prepare":
    command     => "module-assistant -q prepare",
    refreshonly => true,
  }

  exec {"m-a-update":
    command     => "module-assistant -q update",
    refreshonly => true,
    require     => Exec["m-a-prepare"],
  }

  exec {"m-a-install-zaptel":
    command  => "module-assistant -i -q a-i zaptel",
    creates  => "/lib/modules/${kernelrelease}/misc/zaptel.ko",
    require  => Exec["m-a-update"]
  }

  User["asterisk"] {
    groups => "dialout",
  }
}
