class asterisk::voip-only {
  package {
    ["asterisk",
    "asterisk-app-dtmftotext",
    "asterisk-prompt-fr",
    "asterisk-sounds-extra",
    "asterisk-dev",
    "asterisk-sounds-main",
    "asterisk-doc"]:
    ensure => installed,
  }

  service {"asterisk":
    ensure  => running,
    require => [Package["asterisk"], User["asterisk"], Group["asterisk"]],
  }

  exec {"asterisk-reload":
    command     => "/etc/init.d/asterisk reload",
    refreshonly => true,
  }

  user {"asterisk":
    ensure   => present,
    require  => Package["asterisk"],
  }

  group {"asterisk":
    ensure   => present,
    require  => Package["asterisk"],
  }


  file {"/etc/default/asterisk":
    source => "puppet:///asterisk/asterisk.default",
    require => Package["asterisk"],
  }

  # Generic .d configuration directory
  define config-dotd () {
    $dirname = "${name}.d"

    file {"${dirname}":
      ensure  => directory,
      owner   => "root",
      group   => "asterisk",
      mode    => 750,
      require => [Package["asterisk"], Group["asterisk"]],
    }

    # Avoid error messages
    # [Nov 19 16:09:48] ERROR[3364] config.c: *********************************************************
    # [Nov 19 16:09:48] ERROR[3364] config.c: *********** YOU SHOULD REALLY READ THIS ERROR ***********
    # [Nov 19 16:09:48] ERROR[3364] config.c: Future versions of Asterisk will treat a #include of a file that does not exist as an error, and will fail to load that configuration file.  Please ensure that the file '/etc/asterisk/iax.conf.d/*.conf' exists, even if it is empty.
    file {"${dirname}/null.conf":
      ensure  => present,
      owner   => "root",
      group   => "asterisk",
      mode    => 640,
      require => [Package["asterisk"], Group["asterisk"]],
    }

    line{"Include ${dirname}":
      ensure  => present,
      line    => "#include <${dirname}/*.conf>",
      file    => $name,
      require => File[$dirname],
    }
  }

  # Configuration directories
  config-dotd {"/etc/asterisk/sip.conf":}
  config-dotd {"/etc/asterisk/iax.conf":}
  config-dotd {"/etc/asterisk/manager.conf":}
  config-dotd {"/etc/asterisk/queues.conf":}
  config-dotd {"/etc/asterisk/extensions.conf":}
}
