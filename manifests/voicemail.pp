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
