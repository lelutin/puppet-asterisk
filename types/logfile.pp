# @summary Options that can be set for a log file
#
# @see https://wiki.asterisk.org/wiki/display/AST/Logging+Configuration
#
type Asterisk::Logfile = Struct[{
  Optional[formatter] => Enum['default','json'],
  levels => Array[
            Variant[
              Enum['debug','notice','warning','error','dtmf','fax','security','verbose'],
              Pattern[/^verbose\([1-9]\d*\)$/]]
            ,1],
}]
