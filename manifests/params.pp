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

  # service should start
  $manage_service = true

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

  # sip reasonable minimal defaults
  $sip_options = {
    disallow     => ['all'],
    allow        => ['alaw'],
    domain       => [],
    # make all private networks (RFC 1918) be contained in localnet
    localnet     => ['192.168.0.0/255.255.0.0','10.0.0.0/255.0.0.0','172.16.0.0/12','169.254.0.0/255.255.0.0'],
    context      => 'inbound',
    allowguest   => 'no',
    allowoverlap => 'no',
    udpbindaddr  => '0.0.0.0',
    transport    => 'udp',
    tcpenable    => 'no',
    tcpbindaddr  => '0.0.0.0',
    srvlookup    => 'yes',
  }

  # voicemail reasonable defaults
  $voicemail_options = {
    format           => 'wav49|gsm|wav',
    serveremail      => 'asterisk',
    attach           => 'yes',
    minsecs          => 3,
    skipms           => 3000,
    maxsilence       => 10,
    silencethreshold => 128,
    maxlogins        => 3,
    emailbody        => 'Dear ${VM_NAME}:\n\n\tjust wanted to let you know you were just ${IF($["${VM_CIDNUM}" = "${ORIG_VM_CIDNUM}"]?left:forwarded)} a ${VM_DUR} long message (number ${VM_MSGNUM})\nin mailbox ${VM_MAILBOX} from ${VM_CALLERID} <${VM_CIDNUM}>, on ${VM_DATE},\n${IF($["${VM_CIDNUM}" = "${ORIG_VM_CIDNUM}"]?so:(originally sent by ${ORIG_VM_CALLERID} on ${ORIG_VM_DATE})\nso)} you might want to check it when you get a chance.  Thanks!\n\n\t\t\t\t--Asterisk\n',
    emaildateformat  => '%A, %B %d, %Y at %r',
    sendvoicemail    => 'yes',
  }

  # extensions reasonable defaults
  $extensions_options = {
    static          => 'yes',
    writeprotect    => 'no',
    clearglobalvars => 'no',
  }

  # modules reasonable defaults
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
  $modules_global_options = {}

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
