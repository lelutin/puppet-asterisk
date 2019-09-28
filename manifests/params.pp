# @summary Default values for the asterisk class
#
# This class is not intended to be used directly.
#
# @api private
#
class asterisk::params {

  # Cannot call assert_private() here. It seems as though inheritance breaks
  # the checks for the function.

  $iax_general = {
    'allow'             => [],
    'disallow'          => ['lpc10'],
    'bandwidth'         => 'low',
    'jitterbuffer'      => 'no',
    'forcejitterbuffer' => 'no',
    'autokill'          => 'yes',
    # Some added security default options
    'delayreject'       => 'yes',
  }

  $sip_general = {
    'disallow'         => [],
    'allow'            => [],
    'domain'           => [],
    'localnet'         => [],
    'context'          => 'default',
    'allowoverlap'     => 'no',
    'udpbindaddr'      => '0.0.0.0',
    'tcpenable'        => 'no',
    'tcpbindaddr'      => '0.0.0.0',
    'transport'        => 'udp',
    'srvlookup'        => 'yes',
    # Some added security default options
    'allowguest'       => 'no',
    'alwaysauthreject' => 'yes',
  }

  $voicemail_general = {
    'format'           => 'wav49|gsm|wav',
    'serveremail'      => 'asterisk',
    'attach'           => 'yes',
    'skipms'           => 3000,
    'maxsilence'       => 10,
    'silencethreshold' => 128,
    'maxlogins'        => 3,
    # This is not really the default value for emailbody but it makes more
    # sense to be a bit more verbose by default.
    'emailbody'        => file('asterisk/email_body'),
    'emaildateformat'  => '%A, %B %d, %Y at %r',
    'pagerdateformat'  => '%A, %B %d, %Y at %r',
    'sendvoicemail'    => 'yes',
  }

  $extensions_general = {
    'static'          => 'yes',
    'writeprotect'    => 'no',
    'clearglobalvars' => 'no',
  }

  # defines the default parkinglot
  $features_general = {
    'parkext' => '700',
    'parkpos' => '701-720',
    'context' => 'parkedcalls',
  }

  $queues_general = {
    'persistentmembers' => 'yes',
    'monitor-type'      => 'MixMonitor',
  }

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

}
