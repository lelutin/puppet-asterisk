# Configure an asterisk queue
#
# This resource presents a multitude of options, corresponding to different
# options that can be configured for queues. The README file presents links to
# resources that describe what all of the options do.
#
# One parameter is an exception:
#
# $ensure can be set to absent in order to remove a queue
#
define asterisk::queue (
  $ensure                                          = present,
  Optional[String[1]] $strategy                    = undef,
  Array[String[1]]    $members                     = [],
  Optional[String[1]] $memberdelay                 = undef,
  Optional[String[1]] $penaltymemberslimit         = undef,
  Optional[String[1]] $membermacro                 = undef,
  Optional[String[1]] $membergosub                 = undef,
  Optional[String[1]] $context                     = undef,
  Optional[String[1]] $defaultrule                 = undef,
  Optional[String[1]] $maxlen                      = undef,
  Optional[String[1]] $musicclass                  = undef,
  Optional[String[1]] $servicelevel                = undef,
  Optional[String[1]] $weight                      = undef,
  Array[String[1]]    $joinempty                   = [],
  Array[String[1]]    $leavewhenempty              = [],
  Optional[String[1]] $eventwhencalled             = undef,
  Optional[String[1]] $eventmemberstatus           = undef,
  Optional[String[1]] $reportholdtime              = undef,
  Optional[String[1]] $ringinuse                   = undef,
  Optional[String[1]] $monitor_type                = undef,
  Array[String[1]]    $monitor_format              = [],
  Optional[String[1]] $announce                    = undef,
  Optional[String[1]] $announce_frequency          = undef,
  Optional[String[1]] $min_announce_frequency      = undef,
  Optional[String[1]] $announce_holdtime           = undef,
  Optional[String[1]] $announce_position           = undef,
  Optional[String[1]] $announce_position_limit     = undef,
  Optional[String[1]] $announce_round_seconds      = undef,
  Array[String[1]]    $periodic_announce           = [],
  Optional[String[1]] $periodic_announce_frequency = undef,
  Optional[String[1]] $random_periodic_announce    = undef,
  Optional[String[1]] $relative_periodic_announce  = undef,
  Optional[String[1]] $queue_youarenext            = undef,
  Optional[String[1]] $queue_thereare              = undef,
  Optional[String[1]] $queue_callswaiting          = undef,
  Optional[String[1]] $queue_holdtime              = undef,
  Optional[String[1]] $queue_minute                = undef,
  Optional[String[1]] $queue_minutes               = undef,
  Optional[String[1]] $queue_seconds               = undef,
  Optional[String[1]] $queue_thankyou              = undef,
  Optional[String[1]] $queue_reporthold            = undef,
  Optional[String[1]] $wrapuptime                  = undef,
  Optional[String[1]] $timeout                     = undef,
  Optional[String[1]] $timeoutrestart              = undef,
  Optional[String[1]] $timeoutpriority             = undef,
  Optional[String[1]] $retry                       = undef,
  Optional[String[1]] $autofill                    = undef,
  Optional[String[1]] $autopause                   = undef,
  Optional[String[1]] $setinterfacevar             = undef,
  Optional[String[1]] $setqueuevar                 = undef,
  Optional[String[1]] $setqueueentryvar            = undef
) {

  asterisk::dotd::file { "queue_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'queues.d',
    content  => template('asterisk/snippet/queue.erb'),
    filename => "${name}.conf",
  }

}
