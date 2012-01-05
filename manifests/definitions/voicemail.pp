define asterisk::voicemail (
  $ensure = 'present',
  $context,
  $password,
  $user_name = '',
  $email = '',
  $pager_email = '',
  $options = {}) {

  # This is sort of hackish, but without this we'll have collisions.
  line{"${name}-context-${context}":
    ensure  => present,
    line    => "[${context}]",
    file    => "/etc/asterisk/voicemail.conf.d/${context}.conf",
    require => File['/etc/asterisk/voicemail.conf.d'],
    notify  => Exec["asterisk-reload"],
  }

  $real_options = inline_template('<% if options.length -%>|<%= options.keys.collect {|key| value = options[key]; "#{key}=#{value}"}.join(",") -%><% end -%>')
  line{"${context}-${name}":
    ensure  => present,
    line    => "${name} => ${password},${user_name},${email},${pager_email}${real_options}",
    file    => "/etc/asterisk/voicemail.conf.d/${context}.conf",
    require => [File['/etc/asterisk/voicemail.conf.d'], Line["${name}-context-${context}"]],
    notify  => Exec["asterisk-reload"],
  }
}
