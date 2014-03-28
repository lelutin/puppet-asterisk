define asterisk::language {
  $allowed_languages = [
    'de',
    'es-co',
    'fr-armelle',
    'fr-proformatique',
    'it-menardi',
    'it-menardi-alaw',
    'it-menardi-gsm',
    'it-menardi-wav',
    'se',
    'es'
  ]

  if !( $name in $allowed_languages ) {
    fail("Language '${name}' for Asterisk is unsupported.")
  }

  package { "asterisk-prompt-${name}": ensure => installed; }
}
