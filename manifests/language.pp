# This class describes packets needed for the translated asterisk voice prompts
define asterisk::language (
  $language = 'fr',
) {
  $allowed_languages = [
    'de',
    'es',
    'es-co',
    'fr',
    'fr-armelle',
    'fr-proformatique',
    'it',
    'se'
  ]

  if !( $language in $allowed_languages ) {
    fail("Language '${language}' for Asterisk is unsupported.")
  }

  package { "asterisk-prompt-${language}": ensure => installed; }
}
