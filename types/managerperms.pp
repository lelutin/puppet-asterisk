# @summary Possible permissions given to AMI users
#
# @see http://asteriskdocs.org/en/3rd_Edition/asterisk-book-html-chunk/AMI-configuration.html#AMI-readwriteopts List of rights and their meaning
#
type Asterisk::ManagerPerms = Enum[
  'all',
  'system',
  'call',
  'log',
  'verbose',
  'agent',
  'user',
  'config',
  'command',
  'dtmf',
  'reporting',
  'cdr',
  'dialplan',
  'originate',
  'agi',
  'cc',
  'aoc'
]
