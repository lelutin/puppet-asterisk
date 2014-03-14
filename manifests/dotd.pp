# Generic .d configuration directory
define asterisk::dotd (
  $additional_paths = [],
  $content = '',
  $source = ''
) {
  include asterisk::install
  include asterisk::service

  $dirname = ["${name}.d"]
  $cf_file_name = "${name}.conf"
  $paths = [$dirname, $additional_paths]

  file { $paths :
    ensure  => directory,
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0750',
    require => Class['asterisk::install'],
  }

  # Avoid error messages
  # [Nov 19 16:09:48] ERROR[3364] config.c: *********************************************************
  # [Nov 19 16:09:48] ERROR[3364] config.c: *********** YOU SHOULD REALLY READ THIS ERROR ***********
  # [Nov 19 16:09:48] ERROR[3364] config.c: Future versions of Asterisk will treat a #include of a file that does not exist as an error, and will fail to load that configuration file.  Please ensure that the file '/etc/asterisk/iax.conf.d/*.conf' exists, even if it is empty.
  asterisk::dotd::nullfile{ $paths : }

  file { $cf_file_name :
    ensure  => present,
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
    require => Class['asterisk::install'],
    notify  => Class['asterisk::service'],
  }

  if $content != '' {
    if $source != '' {
      fail('Please define only one of $content and $source')
    }

    File[$cf_file_name] {
      content => $content,
    }
  } else {
    $filename = inline_template('<%= File.basename(cf_file_name) -%>')
    File[$cf_file_name] {
      source => $source ? {
        '' => [ "puppet:///modules/site_asterisk/${filename}.${::fqdn}",
                "puppet:///modules/site_asterisk/${filename}",
                "puppet:///modules/asterisk/${filename}"],
        default => $source,
      },
    }
  }
}
