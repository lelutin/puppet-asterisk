define asterisk::context::voicemail (
  $context,
  $password,
  $ensure      = present,
  $user_name   = '',
  $email       = '',
  $pager_email = '',
  $options     = {}
) {

  $real_options = inline_template('<% if options.length -%>|<%= options.keys.collect {|key| value = options[key]; "#{key}=#{value}"}.join(",") -%><% end -%>')
  asterisk::dotd_file{"${context}-${name}.conf":
    ensure   => $ensure,
    content  => "[${context}]\n${name} => ${password},${user_name},${email},${pager_email}${real_options}",
    dotd_dir => 'voicemail.d',
  }

}
