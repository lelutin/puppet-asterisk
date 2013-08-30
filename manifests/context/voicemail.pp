define asterisk::context::voicemail (
  $ensure = 'present',
  $context,
  $password,
  $user_name = '',
  $email = '',
  $pager_email = '',
  $options = {}) {
  require asterisk::voicemail

  # This is sort of hackish, but without this we'll have collisions.
  line{"${name}-context-${context}":
    ensure  => present,
    line    => "[${context}]",
    file    => "/etc/asterisk/voicemail.conf.d/${context}.conf",
    require => File['/etc/asterisk/voicemail.conf.d'],
    notify  => Service['asterisk'],
  }

  $real_options = inline_template('<% if options.length -%>|<%= options.keys.collect {|key| value = options[key]; "#{key}=#{value}"}.join(",") -%><% end -%>')
  # XXX when the line changes, the box definition is duplicated. I need to find
  # a way to delete the old line first.
  line{"${context}-${name}":
    ensure  => present,
    line    => "${name} => ${password},${user_name},${email},${pager_email}${real_options}",
    file    => "/etc/asterisk/voicemail.conf.d/${context}.conf",
    require => [File['/etc/asterisk/voicemail.conf.d'],
                Line["${name}-context-${context}"]],
    notify  => Service['asterisk'],
  }
}
