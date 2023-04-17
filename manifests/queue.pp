# @summary Configure an asterisk queue
#
# This resource presents a multitude of options, corresponding to different
# options that can be configured for queues.
#
# @see http://www.asteriskdocs.org/en/3rd_Edition/asterisk-book-html-chunk/ACD_id288901.html#options_defined_queues Definitions of options
# @see http://www.asteriskdocs.org/en/3rd_Edition/asterisk-book-html-chunk/asterisk-ACD.html
# @see http://www.asteriskdocs.org/en/3rd_Edition/asterisk-book-html-chunk/ACD_id288932.html#ACD_id36004485 Changing penalties dynamically
#
# @example create a queue with 10 max callers and strategy `random`
#   asterisk::queue { 'shortq':
#     stragegy => 'random',
#     maxlen   => 10,
#   }
#
# @todo use better data types. some params should be boolean. some should have an enum.
#
# @param ensure
#   Set this to `absent` in order to remove a queue.
#
# @param strategy
#   Name of the queue strategy that determines which member phones are ringing
#   when there is a call in the queue that needs answering. If this parameter
#   is not defined, the strategy defaults to 'ringall'.
# @param context
#   Name of a dialplan context. Allows a caller to exit the queue by pressing a
#   single DTMF digit. If a context is specified and the caller enters a
#   number, that digit will attempt to be matched in the context specified, and
#   dialplan execution will continue there.
# @param defaultrule
#   Associates a queue rule as defined in queuerules.conf to this queue, which
#   is used to dynamically change the minimum and maximum penalties, which are
#   then used to select an available agent.
# @param maxlen
#   Maximum number of allowed callers in the queue. A value of 0 allows an
#   unlimited number of callers in the queue. If unspecified, defaults to 0.
# @param musicclass
#   Name of a music class as defined in `musiconhold.conf` to be used for this
#   particular queue. You can also override this value with the
#   CHANNEL(musicclass) channel variable.
# @param servicelevel
#   Threshold in seconds for queue waiting time. This can be then used in
#   statistics to determine the number of calls that have passed the
#   `servicelevel` threshold.
#
# @param members
#   List of static members of this queue. Each member should be specified a
#   `Technology/Device_ID`.
# @param memberdelay
#   Optional number of seconds to add as delay before the caller and member get
#   connected to each other.
# @param penaltymemberslimit
#   Optional lower bound to start disregarding penalty if number of members in
#   the queue is lower than this number.
# @param membermacro
#   Name of a macro to be executed just prior to bridging the caller and the
#   queue member.
# @param membergosub
#   If set, run this gosub when connected to the queue member you can override
#   this gosub by setting the gosub option on the queue application
# @param setinterfacevar
#   If set to `yes`, the channel variables `MEMBERINTERFACE`, `MEMBERNAME`,
#   `MEMBERCALLS`, `MEMBERLASTCALL`, `MEMBERPENALTY`, `MEMBERDYNAMIC` and
#   `MEMBERREALTIME` will be set just prior to connecting the caller with the
#   queue member.
# @param setqueuevar
#   If set to `yes`, the channel variables `QUEUENAME`, `QUEUEMAX`,
#   `QUEUESTRATEGY`, `QUEUECALLS`, `QUEUEHOLDTIME`, `QUEUECOMPLETED`,
#   `QUEUEABANDONED`, `QUEUESRVLEVEL` and `QUEUESRVLEVELPERF` will be set just
#   prior to the call being bridged.
# @param setqueueentryvar
#   If set to `yes`, the channel variables `QEHOLDTIME` and `QEORIGINALPOS`
#   will be set just prior to the call being bridged.
# @param weight
#   The weight of a queue. A queue with a higher weight defined will get first
#   priority when members are associated with multiple queues.
# @param reportholdtime
#   If set to `yes`, enables reporting of the caller’s hold time to the queue
#   member prior to bridging.
# @param ringinuse
#   If set to `no`, avoid sending calls to members whose status is `In Use`.
#   Only the SIP channel driver is currently able to accurately report this
#   status.
# @param wrapuptime
#   Number of seconds to keep a member unavailable in a queue after completing
#   a call.
# @param timeout
#   Number of seconds to ring a member’s device. Also see `timeoutpriority`.
# @param timeoutrestart
#   If set to `yes`, resets the timeout for an agent to answer if either a
#   `BUSY` or `CONGESTION` status is received from the channel. This can be
#   useful if the agent is allowed to reject or cancel a call.
# @param timeoutpriority
#   Define which value of `timeout` takes precedence in case of a conflict. Set
#   to `conf` to have the value configured with `timeout` on this resource take
#   precedence. Defaults to `app`, which means the `timeout` value from the
#   `Queue()` application will take precedence.
# @param retry
#   Number of seconds to wait before attempting the next member in the queue if
#   the `timeout` value is exhausted while attempting to ring a member of the
#   queue.
# @param autopause
#   Set this to `yes` to enable the automatic pausing of members who fail to
#   answer a call. A value of `all` causes this member to be paused in all
#   queues they are a member of.
#
# @param joinempty
#   Controls whether a caller is added to the queue when no members are
#   available. Comma-separated options can be included to define how this
#   option determines whether members are available. See reference `Definitions
#   of options` to see what possible values this can take and what they mean.
# @param leavewhenempty
#   control whether callers are kicked out of the queue when members are no
#   longer available to take calls. This can take values similar to
#   `joinempty`.
# @param eventwhencalled
#   If set to `yes` manager events `AgentCalled`, `AgentDump`, `AgentConnect`
#   and `AgentComplete` will be sent to the Asterisk Manager Interface (AMI).
#   If set to vars, all channel variables associated with the agent will also
#   be sent to the AMI. Defaults to `no`.
# @param eventmemberstatus
#   If set to `yes`, the QueueMemberStatus event will be sent to AMI. Note that
#   this may generate a lot of manager events.
# @param monitor_type
#   If set to `MixMonitor`, the `MixMonitor()` application will be used for
#   recording calls within the queue. If not specified, the `Monitor()`
#   application will be used instead. This setting applies specifically for
#   this queue and overrides the general option with the same name.
# @param monitor_format
#   File format to use when recording. If unspecified, calls will not be
#   recorded.
# @param autofill
#   If set to `no`, the queue application will attempt to deliver calls to
#   agents in a serial manner. This means only one call is attempted to be
#   distributed to agents at a time. Additional callers are not distributed to
#   agents until that caller is connected to an agent. If set to `yes`, callers
#   are distributed to available agents simultaneously. This value overrides
#   the value from the general section for this particular queue.
#
# @param announce
#   Filename of an announcement played to the agent that answered the call,
#   typically to let them know what queue the caller is coming from. Useful
#   when the agent is in multiple queues, especially when set to auto-answer
#   the queue.
# @param announce_frequency
#   Number of seconds to wait for before we should announce the caller’s
#   position and/or estimated hold time in the queue. Set this value to zero or
#   let the parameter unspecified to disable.
# @param min_announce_frequency
#   Minimum amount of time, in seconds, that must pass before we announce the
#   caller’s position in the queue again. This is used when the caller’s
#   position may change frequently, to prevent the caller hearing multiple
#   updates in a short period of time.
# @param announce_holdtime
#   Set to `yes` to play the estimated hold time along with the periodic
#   announcements. If set to `once`, the estimated hold time will be played
#   only once. Defaults to `no`.
# @param announce_position
#   Set to `yes` to have periodic announcements always mention current position
#   in the queue. If set to `limit` announcements will only mention the
#   position in the queue if it is within the limit defined by
#   `announce_position_limit`. If set to `more`, announcements will only
#   mention the position in the queue if it is beyond the number in
#   `announce_position_limit`. Defaults to `no`.
# @param announce_position_limit
#   Position in the queue that represents a threshold for announcements if
#   `announce_position` was set to `limit` or `more`.
# @param announce_round_seconds
#   If set to a non-zero value, announcements will mention seconds as well,
#   rounded to the value specified in this parameter.
# @param periodic_announce
#   List of file names of periodic announcements to be played. Prompts are
#   played in the order they are defined. If unset, defaults to
#   `queue-periodic-announce`.
# @param periodic_announce_frequency
#   Time in seconds between periodic announcements to the caller.
# @param random_periodic_announce
#   If set to `yes`, will play the defined periodic announcements in a random
#   order.
# @param relative_periodic_announce
#   If set to `yes`, the periodic_announce_frequency timer will start from when
#   the end of the file being played back is reached, instead of from the
#   beginning. Defaults to `no`.
# @param queue_youarenext
#   Filename of a prompt to play when caller reaches first position in queue.
#   If not defined, will play the default value (“You are now first in line”).
#   If set to an empty value, the prompt will not be played at all.
# @param queue_thereare
#   Filename of a prompt to play in announcements when mentioning how much
#   people are before the caller. If not defined, will play the default value
#   (“There are”). If set to an empty value, the prompt will not be played at
#   all.
# @param queue_callswaiting
#   Filename of a prompt to play in announcements after saying number of calls
#   before caller. If not defined, will play the default value (“calls
#   waiting”). If set to an empty value, the prompt will not be played at all.
# @param queue_holdtime
#   Filename of a prompt to play when starting to announce estimated wait time.
#   If not defined, will play the default value (“The current estimated hold
#   time is”). If set to an empty value, the prompt will not be played at all.
# @param queue_minute
#   Filename of a prompt to play after stating number of estimated minutes, if
#   the number is 1. If not defined, will play the default value (“minute”). If
#   set to an empty value, the prompt will not be played at all.
# @param queue_minutes
#   Filename of a prompt. This is the same as `queue_minute` but for when the
#   number of minutes is more than 1.
# @param queue_seconds
#   Filename of a prompt to play after stating number of estimated seconds. If
#   not defined, will play the default value (“seconds”). If set to an empty
#   value, the prompt will not be played at all.
# @param queue_thankyou
#   Filename of a prompt. If not defined, will play the default value (“Thank
#   you for your patience”). If set to an empty value, the prompt will not be
#   played at all.
# @param queue_reporthold
#   Filename of a prompt. If not defined, will play the default value (“Hold
#   time”). If set to an empty value, the prompt will not be played at all.
#
define asterisk::queue (
  Stdlib::Ensure::File::File $ensure                      = file,
  Optional[String[1]]        $strategy                    = undef,
  Array[String[1]]           $members                     = [],
  Optional[Integer]          $memberdelay                 = undef,
  Optional[String[1]]        $penaltymemberslimit         = undef,
  Optional[String[1]]        $membermacro                 = undef,
  Optional[String[1]]        $membergosub                 = undef,
  Optional[String[1]]        $context                     = undef,
  Optional[String[1]]        $defaultrule                 = undef,
  Optional[Integer]          $maxlen                      = undef,
  Optional[String[1]]        $musicclass                  = undef,
  Optional[String[1]]        $servicelevel                = undef,
  Optional[Integer]          $weight                      = undef,
  Array[String[1]]           $joinempty                   = [],
  Array[String[1]]           $leavewhenempty              = [],
  Optional[String[1]]        $eventwhencalled             = undef,
  Optional[String[1]]        $eventmemberstatus           = undef,
  Optional[String[1]]        $reportholdtime              = undef,
  Optional[String[1]]        $ringinuse                   = undef,
  Optional[String[1]]        $monitor_type                = undef,
  Array[String[1]]           $monitor_format              = [],
  Optional[String[1]]        $announce                    = undef,
  Optional[Integer]          $announce_frequency          = undef,
  Optional[Integer]          $min_announce_frequency      = undef,
  Optional[String[1]]        $announce_holdtime           = undef,
  Optional[String[1]]        $announce_position           = undef,
  Optional[Integer]          $announce_position_limit     = undef,
  Optional[Integer]          $announce_round_seconds      = undef,
  Array[String[1]]           $periodic_announce           = [],
  Optional[Integer]          $periodic_announce_frequency = undef,
  Optional[String[1]]        $random_periodic_announce    = undef,
  Optional[String[1]]        $relative_periodic_announce  = undef,
  Optional[String]           $queue_youarenext            = undef,
  Optional[String]           $queue_thereare              = undef,
  Optional[String]           $queue_callswaiting          = undef,
  Optional[String]           $queue_holdtime              = undef,
  Optional[String]           $queue_minute                = undef,
  Optional[String]           $queue_minutes               = undef,
  Optional[String]           $queue_seconds               = undef,
  Optional[String]           $queue_thankyou              = undef,
  Optional[String]           $queue_reporthold            = undef,
  Optional[Integer]          $wrapuptime                  = undef,
  Optional[Integer]          $timeout                     = undef,
  Optional[String[1]]        $timeoutrestart              = undef,
  Optional[String[1]]        $timeoutpriority             = undef,
  Optional[String[1]]        $retry                       = undef,
  Optional[String[1]]        $autofill                    = undef,
  Optional[String[1]]        $autopause                   = undef,
  Optional[String[1]]        $setinterfacevar             = undef,
  Optional[String[1]]        $setqueuevar                 = undef,
  Optional[String[1]]        $setqueueentryvar            = undef
) {
  $queue_variables = {
    queue_name                  => $name,
    strategy                    => $strategy,
    members                     => $members,
    memberdelay                 => $memberdelay,
    penaltymemberslimit         => $penaltymemberslimit,
    membermacro                 => $membermacro,
    membergosub                 => $membergosub,
    context                     => $context,
    defaultrule                 => $defaultrule,
    maxlen                      => $maxlen,
    musicclass                  => $musicclass,
    servicelevel                => $servicelevel,
    weight                      => $weight,
    joinempty                   => $joinempty,
    leavewhenempty              => $leavewhenempty,
    eventwhencalled             => $eventwhencalled,
    eventmemberstatus           => $eventmemberstatus,
    reportholdtime              => $reportholdtime,
    ringinuse                   => $ringinuse,
    monitor_type                => $monitor_type,
    monitor_format              => $monitor_format,
    announce                    => $announce,
    announce_frequency          => $announce_frequency,
    min_announce_frequency      => $min_announce_frequency,
    announce_holdtime           => $announce_holdtime,
    announce_position           => $announce_position,
    announce_position_limit     => $announce_position_limit,
    announce_round_seconds      => $announce_round_seconds,
    periodic_announce           => $periodic_announce,
    periodic_announce_frequency => $periodic_announce_frequency,
    random_periodic_announce    => $random_periodic_announce,
    relative_periodic_announce  => $relative_periodic_announce,
    queue_youarenext            => $queue_youarenext,
    queue_thereare              => $queue_thereare,
    queue_callswaiting          => $queue_callswaiting,
    queue_holdtime              => $queue_holdtime,
    queue_minute                => $queue_minute,
    queue_minutes               => $queue_minutes,
    queue_seconds               => $queue_seconds,
    queue_thankyou              => $queue_thankyou,
    queue_reporthold            => $queue_reporthold,
    wrapuptime                  => $wrapuptime,
    timeout                     => $timeout,
    timeoutrestart              => $timeoutrestart,
    timeoutpriority             => $timeoutpriority,
    retry                       => $retry,
    autofill                    => $autofill,
    autopause                   => $autopause,
    setinterfacevar             => $setinterfacevar,
    setqueuevar                 => $setqueuevar,
    setqueueentryvar            => $setqueueentryvar,
  }
  asterisk::dotd::file { "queue_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'queues.d',
    content  => epp('asterisk/snippet/queue.epp', $queue_variables),
    filename => "${name}.conf",
  }
}
