class asterisk::french inherits asterisk {

  package { 'asterisk-prompt-fr': ensure => installed; }

  if ($::operatingsystem == 'debian') and ($::lsbdistcodename == 'squeeze') {
    Package['asterisk-prompt-fr'] {
      name => 'asterisk-prompt-fr-armelle',
    }
  }

}

