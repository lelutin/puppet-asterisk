# Configure a voicemail
#
# $context is the name of the context in which the voicemail is assigned.
#
# $password is the authentication password set for accessing the voicemail.
#
# $ensure can be set to absent to remove the voicemail.
#
# $user_name is a name assigned to the voicemail, usually the name of the
#   person using it.
#
# $email is the email address to which voicemail message sounds will be sent.
#
# $pager_email is an email to which a page will be sent upon receiving a
#   voicemail.
#
# $options is a hash containing options that are set for the voicemail. For
#   example, a specific timezone can be set on individual voicemails with the
#   'tz' option.
#
define asterisk::voicemail (
  String[1]            $context,
  Sensitive[String[1]] $password,
  $ensure                           = present,
  String               $user_name   = '',
  String               $email       = '',
  String               $pager_email = '',
  Hash                 $options     = {}
) {

  asterisk::dotd::file{ "${context}-${name}.conf":
    ensure   => $ensure,
    content  => template('asterisk/snippet/voicemail.erb'),
    dotd_dir => 'voicemail.d',
  }

}
