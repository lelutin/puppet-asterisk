define asterisk::queue (
  $ensure = present,
  $strategy = false,
  $members = [],
  $memberdelay = false,
  $penaltymemberslimit = false,
  $membermacro = false,
  $membergosub = false,
  $context = false,
  $defaultrule = false,
  $maxlen = false,
  $musicclass = false,
  $servicelevel = false,
  $weight = false,
  $joinempty = [],
  $leavewhenempty = [],
  $eventwhencalled = false,
  $eventmemberstatus = false,
  $reportholdtime = false,
  $ringinuse = false,
  $monitor_type = false,
  $monitor_format = [],
  $announce = false,
  $announce_frequency = false,
  $min_announce_frequency = false,
  $announce_holdtime = false,
  $announce_position = false,
  $announce_position_limit = false,
  $announce_round_seconds = false,
  $periodic_announce = [],
  $periodic_announce_frequency = false,
  $random_periodic_announce = false,
  $relative_periodic_announce = false,
  $queue_youarenext = false,
  $queue_thereare = false,
  $queue_callswaiting = false,
  $queue_holdtime = false,
  $queue_minute = false,
  $queue_minutes = false,
  $queue_seconds = false,
  $queue_thankyou = false,
  $queue_reporthold = false,
  $wrapuptime = false,
  $timeout = false,
  $timeoutrestart = false,
  $timeoutpriority = false,
  $retry = false,
  $autofill = false,
  $autopause = false,
  $setinterfacevar = false,
  $setqueuevar = false,
  $setqueueentryvar = false
) {

  # Ensure that we can iterate over some of the parameters.
  validate_array($members)
  validate_array($joinempty)
  validate_array($leavewhenempty)
  validate_array($monitor_format)
  validate_array($periodic_announce)

  asterisk::dotd::file {"queue_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'queues.d',
    content  => template('asterisk/snippet/queue.erb'),
    filename => "${name}.conf",
  }

}
