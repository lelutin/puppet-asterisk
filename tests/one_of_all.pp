# This test file is meant to be a quick and dirty acceptance test for the main
# class without arguments and the most simple case for all of the defined
# types. Its purpose is to make it easy to see if something got broken somehow.

class { 'asterisk':
  extensions_globals => {
    'TRUNK'       => 'patate',
    'CHUNKAWOMBA' => Sensitive.new('megamega'),
  }
}

asterisk::agent { 'smith':
  ext        => '7000',
  password   => Sensitive.new('misssteranderson'),
  agent_name => 'smith',
}

asterisk::extensions { 'press_one':
  content => 'exten => 500,1,Answer',
}

asterisk::feature { 'exclusivity':
  options => {
    phone => '555-555-5555',
  }
}

asterisk::iax { 'meetingroom':
  content => "type=user\ncontext=press_one",
}

asterisk::language { 'fr-armelle': }

asterisk::manager { 'michael':
  secret => Sensitive.new('notagoodmanager'),
}

asterisk::queue { 'tail': }

asterisk::sip { 'skippy': }

asterisk::voicemail { '200':
  context  => 'press_one',
  password => Sensitive.new('whoyougonnacall'),
}

asterisk::registry::iax { 'providerX':
  server   => 'foo.local',
  user     => 'carolina',
  password => Sensitive.new('thisisapasswordwhatyoulookingat'),
}

asterisk::registry::sip { 'myphone':
  server => 'sipphone.local',
  user   => 'line1',
}

