class asterisk::config {

  case $::operatingsystem {
    'CentOS', 'Fedora', 'Scientific', 'RedHat', 'Amazon', 'OracleLinux': {
      $service_settings_path = "/etc/sysconfig/${apache::service_name}"
    }
    'Debian', 'Ubuntu': {
      $service_settings_path = "/etc/default/${apache::service_name}"
    }
    default: {
      fail("Unsupported system '${::operatingsystem}'.")
    }
  }

  shellvar {'RUNASTERISK':
    ensure  => present,
    target  => $service_settings_path,
    value   => 'yes',
    require => Package['asterisk'],
    notify  => Service['asterisk'],
  }

}
