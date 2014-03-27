define asterisk::agent (
  $ext,
  $password,
  $agent_name,
  $ensure = present,
  $groups = []
) {

  validate_array($groups)

  asterisk::dotd::file {"${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'agents.d',
    content  => template('asterisk/snippet/agent.erb'),
  }

}
