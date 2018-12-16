# @summary Configure a voicemail
#
# @example voicemail with email address
#   asterisk::voicemail { 'taro':
#     context  => 'support2',
#     password => Sensitive.new('557722981749'),
#     email    => 'taro.suupaa@support.com',
#   }
#
# @param context
#   Name of the context in which the voicemail is assigned.
# @param password
#   Authentication password set for accessing the voicemail. This is usually a
#   series of numbers so that phones can dial the password, but it can be a
#   textual password as well.
# @param ensure
#   Set to `absent` to remove the voicemail.
# @param user_name
#   Name assigned to the voicemail, usually the name of the person using it.
# @param email
#   Email address to which voicemail message sounds will be sent.
# @param pager_email
#   Email address to which a page will be sent upon receiving a voicemail.
# @param options
#   Hash containing options that are set for the voicemail. For
#   example, a specific timezone can be set on individual voicemails with the
#   'tz' option. Options are set in the file as `key = value`.
#
define asterisk::voicemail (
  String[1]            $context,
  Sensitive[String[1]] $password,
  $ensure                           = present,
  Optional[String[1]]  $user_name   = undef,
  Optional[String[1]]  $email       = undef,
  Optional[String[1]]  $pager_email = undef,
  Hash[String,String]  $options     = {}
) {

  asterisk::dotd::file{ "${context}-${name}.conf":
    ensure   => $ensure,
    content  => template('asterisk/snippet/voicemail.erb'),
    dotd_dir => 'voicemail.d',
  }

}
