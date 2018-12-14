# Configure an asterisk agent
#
# $ext specifies the extension corresponding to the agent.
#
# $password is the login password of the agent.
#
# $agent_name is name by which the agent is referred to within dialplan.
#
# $ensure can be set to absent to remove a given agent.
#
# $groups is a list of groups to which the agent is associated.
#
define asterisk::agent (
  String                    $ext,
  Sensitive[String]         $password,
  String                    $agent_name,
  Enum['present', 'absent'] $ensure = present,
  Array                     $groups = []
) {

  asterisk::dotd::file {"agent_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'agents.d',
    content  => template('asterisk/snippet/agent.erb'),
    filename => "${name}.conf",
  }

}
