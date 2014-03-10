# This class describes packets needed for the translated asterisk voice prompts
define asterisk::language (
  $language
) {
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

  if !( $language in $allowed_languages ) {
    fail("Language '${language}' for Asterisk is unsupported.")
  }

  package { "asterisk-prompt-${language}": ensure => installed; }
}
