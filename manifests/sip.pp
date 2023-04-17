# @summary Configure a SIP peer, a user or a template for the previous.
#
# @note It is generally recommended to avoid assigning hostname to a `sip.conf`
#   section like `[provider.com]`.
# @note It is generally recommended to use separate inbound and outbound
#   sections for SIP providers (instead of type=friend) if you have calls in
#   both directions
#
# @example create sip peer of providerZ
#   asterisk::sip { 'providerZ':
#     account_type => 'peer',
#     disallow     => ['all'],
#     allow        => ['ulaw'],
#     host         => 'sip-host.local',
#     secret       => Sensitive.new('callthisasecret'),
#   }
#
# @see https://www.voip-info.org/asterisk-config-sipconf/
#
# @todo use better data types. some should be boolean, some should have an enum
#
# @param ensure
#   Set this to `absent` in order to remove SIP configuration.
# @param template_name
#   Set this to `!` if you are creating a template. Set this to any name of a
#   template section to inherit options from it.
#
# @param account_type
#   Define how calls are handled. Roughly, `peer` handles outbound and inbound
#   calls matches calls by ip/port. `user` handles only inbound calls and
#   matches calls by `authname` and `secret`. `friend` handles both inbound and
#   outbound calls where inbound calls are matched by `authname` and `secret`
#   (like a `user`) but outbound calls are matched by ip and port like a
#   `peer`.
# @param username
#   Deprecated option in asterisk. You probably want to use `defaultuser`
#   instead.
# @param defaultuser
#   Authentication user name.
# @param secret
#   Authentication secret for inbound connections.
# @param md5secret
#   MD5-Hash of `<user>:==SIP_realm==:<secret>` (can be used instead of
#   `secret`). Default for authenticating to an Asterisk server when SIP realm
#   is not explicitly declared is `<user>:asterisk:<secret>`.
# @param remotesecret
#   Authentication secret for outbound connections. If this is not set,
#   `$secret` is used for outbound connections.
# @param context
#   Name of the dialplan context that is used as starting point when an inbound
#   call is received through this peer/user.
# @param canreinvite
#   Deprecated option in asterisk: was renamed to `directmedia`. Whether or not
#   to issue a reinvite to the client unless really necessary. This is used to
#   interoperate with some (buggy) hardware that crashes if we reinvite, such
#   as the common Cisco ATA 186. Setting this to `nonat` will allow reinvite
#   when local, deny reinvite when NAT. Finally setting this to `update` will
#   use `UPDATE` instead of `INVITE`.
# @param directmedia
#   By default, Asterisk tries to re-invite media streams to an optimal path.
#   If there's no reason for Asterisk to stay in the media path, the media will
#   be redirected. This does not really work well in the case where Asterisk is
#   outside and the clients are on the inside of a NAT. In that case, you want
#   to set this parameter to `nonat`. `nonat` will allow media path redirection
#   (reinvite) but only when the peer where the media is being sent is known to
#   not be behind a NAT (as the RTP core can determine it based on the apparent
#   IP address the media arrives from). If you set this parameter to `update`,
#   Asterisk will use an `UPDATE` command instead of an `INVITE` command to
#   redirect media. `update` can also be combined with `nonat` with the value
#   `nonat,update`.
# @param directrtpsetup
#   Set this to `true` to enable the new experimental direct RTP setup. This
#   sets up the call directly with media peer-2-peer without re-invites.  Will
#   not work for video and cases where the callee sends RTP payloads and fmtp
#   headers in the 200 OK that does not match the callers INVITE. This will
#   also fail if directmedia is enabled when the device is actually behind NAT.
# @param directmediadeny
#   List of CIDR prefixes (e.g. of the form `prefix/number of bits for mask` --
#   for example `172.16.0.0/16`) that should be denied passing directmedia to
#   other peers. You can use this if some of your phones are on IP addresses
#   that can not reach each other directly. This way you can force RTP to
#   always flow through asterisk in such cases. See also `directmediapermit`.
# @param directmediapermit
#   List of CIDR prefixes that should be allowed passing directmedia to other
#   peers. See `directmediadeny`.
# @param host
#   Set this to `dynamic` to require the device to register itself before
#   authenticating. Set to a hostname or IP address to match only for this host
#   or IP address.
# @param insecure
#   If set to `port`, allow matching of peer by IP address without matching
#   port number. If set to `invite`, do not require authentication of incoming
#   INVITEs. If set to `no`, all connections will be authenticated regardless
#   of port or IP address.  Defaults to `no`.
# @param language
#   Language code to define prompts for this peer/user.
# @param nat
#   Use methods to bypass issues when a phone is behind a NAT. This setting is
#   not useful for when the asterisk server is the one behind the NAT. Set this
#   to `yes` to ignore the address information in the SIP and SDP headers. Set
#   this to `force_rport` fore RFC 3581 behavior and disable symmetric RTP
#   support. Set this to `comedia` to enable RFC 3581 behavior if the remote
#   side requests it and enables symmetric RTP support.
# @param qualify
#   If set to `yes`, the check if client is reachable every `qualifyfreq`
#   seconds (defaults to 60 seconds). If set to an integer number, corresponds
#   to `yes` and defines the timeout in milliseconds after a check packet is
#   sent: when the timeout is reached, a peer is considered offline. Valid only
#   with `type` set to `peer`.
# @param vmexten
#   Name of dialplan extension to reach mailbox. When unspecified, defaults to
#   `asterisk`. Valid only with `type` set to `peer`.
# @param callerid
#   Caller ID information used when nothing else is available. When
#   unspecified, defaults to `asterisk`.
# @param call_limit
#   Number of simultaneous calls through this user/peer.
# @param callgroup
#   Call groups for calls to this device.
# @param mailbox
#   Voicemail extension (for message waiting indications). Not valid for `type`
#   set to `user`.
# @param pickupgroup
#   Group that can pickup fellow workers’ calls using `*8` and the `Pickup()`
#   application on the `*8` extension.
# @param fromdomain
#   Default `From:` domain in SIP messages when acting as a SIP UAC (client).
# @param fromuser
#   User to put in `from` instead of `$CALLERID(number)` (overrides the
#   callerid) when placing calls _to_ a peer (another SIP proxy). Valid only
#   with `type` set to `peer`.
# @param outboundproxy
#   SRV name (excluding the _sip._udp prefix), hostname, or IP address of the
#   outbound SIP Proxy. Valid only with `type` set to `peer`.
# @param t38pt_udptl
#   Enable T.83 Fax support. Set to `yes` to enable T.38 with FEC error
#   correction. Additionally, you can add comma-separated options: `redundancy`
#   enables redundancy error correction. `none` disables error correction.
#   `maxdatagram=NN` overrides the maximum datagram value to NN bytes (useful
#   for some problematic cases like Cisco media gateways).
# @param disallow
#   List of codecs to disallow for this peer/user. The list can contain `all` to
#   disallow all known codecs. If set to `all`, codecs that are present in the
#   `allow` list will override this setting, so this can be used to restrict to
#   a narrow number of codecs.
# @param allow
#   List of codecs to allow for this peer/user. The list can contain `all` to
#   allow all known codecs. If set to `all`, codecs in `disallow` will override
#   this setting, so this can be used to blacklist only a narrow set of codecs.
# @param dtmfmode
#   How the client handles DTMF signalling. Defaults to `rfc2833`. Warning:
#   `inband` leads to very high CPU load.
# @param transports
#   Accepted transport types for this peer/user. Can be `udp`, `tcp` or both
#   with the order defining which is set as default (first value is default).
# @param encryption
#   Set to `yes` to offer SRTP encrypted media (and only SRTP encrypted media)
#   on outgoing calls to a peer. Calls will fail with `HANGUPCAUSE=58` if the
#   peer does not support SRTP. Defaults to `no`.
# @param access
#   List of permit/deny rules for CIDR prefixes like `prefix/mask`. Each
#   element of the list should be a one element hash that specifies either
#   'permit' or 'deny' as a key and the CIDR prefix as its value. Order
#   Matters! – Rules are placed in the configuration file in the same order as
#   elements were inserted into the list. The last matching deny/permit rule is
#   the one used. If no rule matches, then the connection is permitted.
# @param trustrpid
#   If a Remote-Party-ID SIP header should be sent. Defaults to `no`.
# @param sendrpid
#   If Remote-Party-ID SIP header should be trusted. Defaults to `no`.
#
define asterisk::sip (
  Stdlib::Ensure::File::File                 $ensure            = file,
  # lint:ignore:optional_default
  Optional[String[1]]                        $template_name     = undef,
  Optional[String[1]]                        $account_type      = 'friend',
  Optional[String[1]]                        $username          = undef,
  Optional[String[1]]                        $defaultuser       = undef,
  Optional[Sensitive[String[1]]]             $secret            = undef,
  Optional[String[1]]                        $md5secret         = undef,
  Optional[Sensitive[String[1]]]             $remotesecret      = undef,
  Optional[String[1]]                        $context           = undef,
  Optional[String[1]]                        $canreinvite       = undef,
  Optional[String[1]]                        $directmedia       = 'no',
  Optional[Boolean]                          $directrtpsetup    = true,
  Array[String[1]]                           $directmediadeny   = [],
  Array[String[1]]                           $directmediapermit = [],
  Optional[String[1]]                        $host              = 'dynamic',
  Optional[String[1]]                        $insecure          = 'no',
  Optional[String[1]]                        $language          = 'en',
  Optional[String[1]]                        $nat               = undef,
  Optional[String[1]]                        $qualify           = 'no',
  Optional[String[1]]                        $vmexten           = undef,
  Optional[String[1]]                        $callerid          = undef,
  Optional[Integer]                          $call_limit        = undef,
  Optional[String[1]]                        $callgroup         = undef,
  Optional[String[1]]                        $mailbox           = undef,
  Optional[String[1]]                        $pickupgroup       = undef,
  Optional[String[1]]                        $fromdomain        = undef,
  Optional[String[1]]                        $fromuser          = undef,
  Optional[String[1]]                        $outboundproxy     = undef,
  Optional[String[1]]                        $t38pt_udptl       = undef,
  Array[String[1]]                           $disallow          = [],
  Array[String[1]]                           $allow             = [],
  Optional[String[1]]                        $dtmfmode          = undef,
  Array[String[1]]                           $transports        = [],
  Optional[String]                           $encryption        = undef,
  Array[Asterisk::Access]                    $access            = [],
  Optional[Enum['yes', 'no']]                $trustrpid         = undef,
  Optional[Enum['yes', 'no', 'pai', 'rpid']] $sendrpid          = undef
  # lint:endignore
) {
  if $canreinvite !~ Undef {
    deprecation(@(DEPRECATED_OPTION)
      The option "canreinvite" was deprecated by asterisk and replaced with
      directmedia. You should check asterisk documentation and use the new
      option instead.
      | DEPRECATED_OPTION
      )
  }

  if $directrtpsetup =~ Boolean {
    $real_directrtpsetup = bool2str($directrtpsetup, 'yes', 'no')
  }
  else {
    $real_directrtpsetup = $directrtpsetup
  }

  $sip_variables = {
    peer_name         => $name,
    template_name     => $template_name,
    account_type      => $account_type,
    username          => $username,
    defaultuser       => $defaultuser,
    secret            => $secret,
    md5secret         => $md5secret,
    remotesecret      => $remotesecret,
    context           => $context,
    canreinvite       => $canreinvite,
    directmedia       => $directmedia,
    directrtpsetup    => $directrtpsetup,
    directmediadeny   => $directmediadeny,
    directmediapermit => $directmediapermit,
    host              => $host,
    insecure          => $insecure,
    language          => $language,
    nat               => $nat,
    qualify           => $qualify,
    vmexten           => $vmexten,
    callerid          => $callerid,
    call_limit        => $call_limit,
    callgroup         => $callgroup,
    mailbox           => $mailbox,
    pickupgroup       => $pickupgroup,
    fromdomain        => $fromdomain,
    fromuser          => $fromuser,
    outboundproxy     => $outboundproxy,
    t38pt_udptl       => $t38pt_udptl,
    disallow          => $disallow,
    allow             => $allow,
    dtmfmode          => $dtmfmode,
    transports        => $transports,
    encryption        => $encryption,
    access            => $access,
    trustrpid         => $trustrpid,
    sendrpid          => $sendrpid,
  }
  asterisk::dotd::file { "sip_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'sip.d',
    content  => epp('asterisk/snippet/sip.epp', $sip_variables),
    filename => "${name}.conf",
  }
}
