# Install packages that are necessary for an asterisk server.
class asterisk::install {

  package {
    [$asterisk::package_name,
    'asterisk-core-sounds-en',
    'asterisk-core-sounds-en-gsm']:
    ensure => installed,
  }

}
