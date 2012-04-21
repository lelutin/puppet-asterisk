# Generic .d configuration directory
define asterisk::config_dotd (
  $content = '',
  $source = '') {

  file { $dirname :
    ensure  => directory,
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0750',
    require => [Package['asterisk'], Group['asterisk']],
  }

  # Avoid error messages
  # [Nov 19 16:09:48] ERROR[3364] config.c: *********************************************************
  # [Nov 19 16:09:48] ERROR[3364] config.c: *********** YOU SHOULD REALLY READ THIS ERROR ***********
  # [Nov 19 16:09:48] ERROR[3364] config.c: Future versions of Asterisk will treat a #include of a file that does not exist as an error, and will fail to load that configuration file.  Please ensure that the file '/etc/asterisk/iax.conf.d/*.conf' exists, even if it is empty.
  file {"${dirname}/null.conf":
    ensure  => present,
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
    require => [Package['asterisk'], Group['asterisk']],
  }

  if $content != '' {
    if $source != '' {
      fail('Please define only one of $content and $source')
    }

    File[$name] {
      content => $content,
    }
  } else {
    $filename = inline_template('<%= File.basename(name) -%>')
    File[$name] {
      source => $source ? {
        '' => [ "puppet:///modules/site-asterisk/${filename}.${::fqdn}",
                "puppet:///modules/site-asterisk/${filename}",
                "puppet:///modules/asterisk/${filename}"],
        default => $source,
      },
    }
  }
}
