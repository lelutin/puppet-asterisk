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
  $context,
  $password,
  $ensure      = present,
  $user_name   = '',
  $email       = '',
  $pager_email = '',
  $options     = {}
) {

  validate_string($context)
  validate_string($password)
  validate_string($user_name)
  validate_string($email)
  validate_string($pager_email)
  validate_hash($options)

  $real_options = inline_template('<% if options.length -%>|<%= options.keys.collect {|key| value = options[key]; "#{key}=#{value}"}.join(",") -%><% end -%>')
  asterisk::dotd::file{"${context}-${name}.conf":
    ensure   => $ensure,
    content  => "[${context}]\n${name} => ${password},${user_name},${email},${pager_email}${real_options}",
    dotd_dir => 'voicemail.d',
  }

}
