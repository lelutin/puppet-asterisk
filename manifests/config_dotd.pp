# Generic .d configuration directory
define asterisk::config_dotd () {
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
