# @summary Configure an asterisk manager
#
# @example manager with default authorizations that can connect from LAN.
#   asterisk::manager { 'sophie':
#     secret => Sensitive.new('youllneverguesswhatitis'),
#     permit => ['192.168.120.0/255.255.255.0'],
#   }
#
# @see http://asteriskdocs.org/en/3rd_Edition/asterisk-book-html-chunk/AMI-configuration.html#AMI_id265404
# @see https://www.voip-info.org/asterisk-config-managerconf/
#
# @param secret
#   Authentication password for the manager.
# @param ensure
#   Set to `absent` to remove the manager.
# @param manager_name
#   Can be used to override the name of the manager. By default the
#   name of the manager corresponds to `$name`.
# @param deny
#   List of IP specifications that are denied access to the manager.  Denied
#   IPs can be overridden by `$permit`. This makes it possible to only permit
#   access to some IP addresses. Default value is to deny access to everybody.
# @param permit
#   List of IP specifications that are permitted access to the manager.
#   Defaults to premitting only localhost.
# @param read
#   List of authorizations given to the manager to read certain information or
#   configuration. Defaults to `system` and `call`.
# @param write
#   List of authorizations given to the manager to write (change) certain
#   information or configuration. Defaults to `system` and `call`.
# @param writetimeout
#   Timeout in milliseconds used by Asterisk when writing data to the AMI
#   connection for this user.
# @param displayconnects
#   Set this to no to avoid reporting connections to the AMI as verbose
#   messages printed to the Asterisk console.
# @param eventfilter
#   Whitelist- or blacklist-style filtering of manager events before they are
#   delivered to the AMI client application. Filters are specified using a
#   regular expression. A specified filter is a whitelist filter unless
#   preceded by an exclamation point.
#
define asterisk::manager (
  Sensitive[String[1]]          $secret,
  Stdlib::Ensure::File::File    $ensure          = file,
  String[1]                     $manager_name    = $name,
  Array[String[1]]              $deny            = ['0.0.0.0/0.0.0.0'],
  Array[String[1]]              $permit          = ['127.0.0.1/255.255.255.255'],
  Array[Asterisk::ManagerPerms] $read            = ['system', 'call'],
  Array[Asterisk::ManagerPerms] $write           = ['system', 'call'],
  Integer                       $writetimeout    = 100,
  Boolean                       $displayconnects = true,
  Optional[String]              $eventfilter     = undef,
) {
  $wo_rights = ['config','command','originate']
  $wo_rights.each |String $right| {
    if $right in $read {
      fail("write-only right '${right}' given to the \$read parameter")
    }
  }

  $ro_rights = ['log','verbose','dtmf','cdr','dialplan','cc']
  $ro_rights.each |String $right| {
    if $right in $write {
      fail("read-only right '${right}' given to the \$write parameter")
    }
  }

  $manager_variables = {
    manager_name    => $manager_name,
    secret          => $secret,
    deny            => $deny,
    permit          => $permit,
    read            => $read,
    write           => $write,
    writetimeout    => $writetimeout,
    displayconnects => bool2str($displayconnects, 'yes', 'no'),
    eventfilter     => $eventfilter,
  }
  asterisk::dotd::file { "manager_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'manager.d',
    content  => epp('asterisk/snippet/manager.epp', $manager_variables),
    filename => "${name}.conf",
  }
}
