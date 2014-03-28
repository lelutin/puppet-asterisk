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
# * Gabriel Filion <gabster@lelutin.ca>
#
class asterisk::params {

  $manage_service = true

  $confdir = '/etc/asterisk'

  $iax_options = {
    'disallow'          => ['lpc10'],
    'bandwidth'         => 'low',
    'jitterbuffer'      => 'no',
    'forcejitterbuffer' => 'no',
    'autokill'          => 'yes',
  }

  $sip_options = {
    'disallow'     => [],
    'allow'        => [],
    'domain'       => [],
    'localnet'     => [],
    'context'      => 'default',
    'allowoverlap' => 'no',
    'udpbindaddr'  => '0.0.0.0',
    'tcpenable'    => 'no',
    'tcpbindaddr'  => '0.0.0.0',
    'transport'    => 'udp',
    'srvlookup'    => 'yes',
  }

  $voicemail_options = {
    'format'           => 'wav49|gsm|wav',
    'serveremail'      => 'asterisk',
    'attach'           => 'yes',
    'skipms'           => 3000,
    'maxsilence'       => 10,
    'silencethreshold' => 128,
    'maxlogins'        => 3,
    # This is not really the default value for emailbody but it makes more
    # sense to be a bit more verbose by default.
    'emailbody'        => 'Dear ${VM_NAME}:\n\n\tjust wanted to let you know you were just ${IF($["${VM_CIDNUM}" = "${ORIG_VM_CIDNUM}"]?left:forwarded)} a ${VM_DUR} long message (number ${VM_MSGNUM})\nin mailbox ${VM_MAILBOX} from ${VM_CALLERID} <${VM_CIDNUM}>, on ${VM_DATE},\n${IF($["${VM_CIDNUM}" = "${ORIG_VM_CIDNUM}"]?so:(originally sent by ${ORIG_VM_CALLERID} on ${ORIG_VM_DATE})\nso)} you might want to check it when you get a chance.  Thanks!\n\n\t\t\t\t--Asterisk\n',
    'emaildateformat'  => '%A, %B %d, %Y at %r',
    'pagerdateformat'  => '%A, %B %d, %Y at %r',
    'sendvoicemail'    => 'yes',
  }

  $extensions_options = {
    'static'          => 'yes',
    'writeprotect'    => 'no',
    'clearglobalvars' => 'no',
  }

  $agents_multiplelogin = true

  # defines the default parkinglot
  $features_options = {
    'parkext' => '700',
    'parkpos' => '701-720',
    'context' => 'parkedcalls',
  }

  $queues_options = {
    'persistentmembers' => 'yes',
    'monitor-type'      => 'MixMonitor',
  }

  $modules_autoload = true
  $modules_noload = [
    'pbx_gtkconsole.so',
    'pbx_kdeconsole.so',
    'app_intercom.so',
    'chan_modem.so',
    'chan_modem_aopen.so',
    'chan_modem_bestdata.so',
    'chan_modem_i4l.so',
    'chan_capi.so',
    'chan_alsa.so',
    'cdr_sqlite.so',
    'app_directory_odbc.so',
    'res_config_odbc.so',
    'res_config_pgsql.so'
  ]
  $modules_load = ['res_musiconhold.so']

  $manager_enable = true
  $manager_port = 5038
  $manager_bindaddr = '127.0.0.1'

  #### Internal module values

  # packages
  case $::operatingsystem {
    'CentOS', 'Fedora', 'Scientific', 'RedHat', 'Amazon', 'OracleLinux': {
      # main application
      $package_name = 'asterisk'
    }
    'Debian', 'Ubuntu': {
      # main application
      $package_name = 'asterisk'
    }
    default: {
      fail("\"${module_name}\" provides no package default value for \"${::operatingsystem}\"")
    }
  }

  # service parameters
  case $::operatingsystem {
    'CentOS', 'Fedora', 'Scientific', 'RedHat', 'Amazon', 'OracleLinux': {
      $service_name = 'asterisk'
    }
    'Debian', 'Ubuntu': {
      $service_name = 'asterisk'
    }
    default: {
      fail("\"${module_name}\" provides no service parameters for \"${::operatingsystem}\"")
    }
  }

}
