# @summary Configure an asterisk agent
#
# @example Basic agent
#   asterisk::agent { 'provocateur':
#     ext        => '700',
#     password   => Sensitive.new('supersecret'),
#     agent_name => 'provocateur',
#   }
#
# @see https://www.voip-info.org/asterisk-cmd-agentlogin Dynamic agent login
# @see https://www.voip-info.org/asterisk-cmd-addqueuemember Adding agents to queues
# @see https://www.voip-info.org/asterisk-cmd-removequeuemember Removing agents from queues
#
# @param ext
#   Extension corresponding to the agent.
# @param password
#   Login password of the agent.
# @param agent_name
#   Name by which the agent is referred to within dialplan.
# @param ensure
#   Can be set to absent to remove a given agent.
# @param groups
#   List of groups to which the agent is associated.
#
define asterisk::agent (
  String                     $ext,
  Sensitive[String]          $password,
  String                     $agent_name,
  Stdlib::Ensure::File::File $ensure = file,
  Array[String[1]]           $groups = []
) {
  $agent_variables = {
    groups     => $groups,
    ext        => $ext,
    password   => $password,
    agent_name => $agent_name,
  }
  asterisk::dotd::file { "agent_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'agents.d',
    content  => epp('asterisk/snippet/agent.epp', $agent_variables),
    filename => "${name}.conf",
  }
}
