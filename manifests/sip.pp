# Configure general SIP options
#
# $ensure can be set to absent in order to remove SIP configuration.
#
# All options correspond to SIP options that can be set. See the README to find
# information about those options.
#
define asterisk::sip (
  $ensure                            = present,
  Optional[String[1]] $username      = undef,
  Optional[String[1]] $defaultuser   = undef,
  Optional[String[1]] $template_name = undef,
  Optional[Sensitive[String[1]]] $secret        = undef,
  Optional[String[1]] $context       = undef,
  Optional[String[1]] $account_type  = 'friend',
  Optional[String[1]] $canreinvite   = 'no',
  Optional[String[1]] $host          = 'dynamic',
  Optional[String[1]] $insecure      = 'no',
  Optional[String[1]] $language      = 'en',
  Optional[String[1]] $nat           = undef,
  Optional[String[1]] $qualify       = 'no',
  Optional[String[1]] $vmexten       = undef,
  Optional[String[1]] $callerid      = undef,
  Optional[String[1]] $calllimit     = undef,
  Optional[String[1]] $callgroup     = undef,
  Optional[String[1]] $mailbox       = undef,
  Optional[String[1]] $md5secret     = undef,
  Optional[String[1]] $pickupgroup   = undef,
  Optional[String[1]] $fromdomain    = undef,
  Optional[String[1]] $fromuser      = undef,
  Optional[String[1]] $outboundproxy = undef,
  Optional[String[1]] $t38pt_udptl   = undef,
  Array[String[1]]    $disallow      = [],
  Array[String[1]]    $allow         = [],
  Optional[String[1]] $dtmfmode      = undef,
  Array[String[1]]    $transports    = [],
  Optional[String]    $encryption    = '',
  Array[String[1]]    $deny          = [],
  Array[String[1]]    $permit        = [],
) {

  asterisk::dotd::file { "sip_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'sip.d',
    content  => template('asterisk/snippet/sip.erb'),
    filename => "${name}.conf",
  }
}
