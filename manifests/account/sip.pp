define asterisk::account::sip (
  $ensure = 'present',

  $username = true,
  $defaultuser = true,
  $template_name = false,

  $secret  = false,
  $context = false,

  $account_type = 'friend',
  $canreinvite = 'no',
  $host = 'dynamic',
  $insecure = 'no',
  $language = 'en',
  $nat = 'no',
  $qualify = '1000',
  $vmexten = '*97',

  $callerid = false,
  $calllimit = false,
  $callgroup = false,
  $mailbox = false,
  $md5secret = false,
  $pickupgroup = false,

  $disallow = [],
  $allow = [],
  $dtmfmode = false) {

  file {"/etc/asterisk/sip.conf.d/${name}.conf":
    ensure  => $ensure,
    content => template('asterisk/account-sip.erb'),
    notify  => Exec['asterisk-reload'],
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
    require => File['/etc/asterisk/sip.conf.d'],
  }
}
