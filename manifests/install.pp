class asterisk::install {

  package {
    [$asterisk::params::package,
    'asterisk-core-sounds-en-alaw',
    'asterisk-core-sounds-en-gsm']:
    ensure => installed,
  }

}
