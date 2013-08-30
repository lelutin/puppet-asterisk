# == Class: asterisk::params
#
# This class exists to
# 1. Declutter the default value assignment for class parameters.
# 2. Manage internally used module variables in a central place.
#
# Therefore, many operating system dependent differences (names, paths, ...)
# are addressed in here.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class is not intended to be used directly.
#
#
# === Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#
# === Authors
#
# * Maximilian Ronniger <mailto:mxr@rise-world.com>
#
class asterisk::params {

  #### Default values for the parameters of the main module class, init.pp

  # ensure
  $ensure = 'present'

  # autoupgrade
  $autoupgrade = false

  # restart on configuration change?
  $restart_on_change = true

  # service status
  $status = 'enabled'

  # configuration directory
  $confdir = '/etc/asterisk'

  # iax reasonable defaults
  $iax_options = {
    disallow          => ['lpc10'],
    allow             => ['gsm'],
    delayreject       => 'yes',
    bandwidth         => 'high',
    jitterbuffer      => 'yes',
    forcejitterbuffer => 'yes',
    maxjitterbuffer   => '1000',
    maxjitterinterps  => '10',
    resyncthreshold   => '1000',
    trunktimestamps   => 'yes',
    autokill          => 'yes',
  }

  #### Internal module values

  # packages
  case $::operatingsystem {
    'CentOS', 'Fedora', 'Scientific', 'RedHat', 'Amazon', 'OracleLinux': {
      # main application
      $package = [ 'asterisk' ]
    }
    'Debian', 'Ubuntu': {
      # main application
      $package = [ 'asterisk' ]
    }
    default: {
      fail("\"${module_name}\" provides no package default value
            for \"${::operatingsystem}\"")
    }
  }

  # service parameters
  case $::operatingsystem {
    'CentOS', 'Fedora', 'Scientific', 'RedHat', 'Amazon', 'OracleLinux': {
      $service_name          = 'asterisk'
      $service_hasrestart    = true
      $service_hasstatus     = true
      $service_pattern       = $service_name
      $service_provider      = 'redhat'
      $service_settings_path = "/etc/sysconfig/${service_name}"
    }
    'Debian', 'Ubuntu': {
      $service_name          = 'asterisk'
      $service_hasrestart    = true
      $service_hasstatus     = true
      $service_pattern       = $service_name
      $service_provider      = 'debian'
      $service_settings_path = "/etc/default/${service_name}"
    }
    default: {
      fail("\"${module_name}\" provides no service parameters
            for \"${::operatingsystem}\"")
    }
  }

}
