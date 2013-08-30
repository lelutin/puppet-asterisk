# This Class descripes packets needed for the translated asterisk voice promtsk
class asterisk::language (
  $language = 'fr',
)
{
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
  if $language in $allowed_languages{
    package { "asterisk-prompt-${language}": ensure => installed; }

    if ($::operatingsystem == 'debian') and ($::lsbdistcodename == 'squeeze') {
      Package['asterisk-prompt-fr'] {
        name => 'asterisk-prompt-fr-armelle',
      }
    }
  }
}
