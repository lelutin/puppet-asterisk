puppet module to install and configure Asterisk
===============================================

To install Asterisk on a server, simply use the following:

  include asterisk

This will install a plain version of Asterisk without any extra 
Futures enabled. To enable any of the extra futures do the following:

```puppet
  include 'asterisk'
  include 'asterisk::dahdi'
```

To include french sounds, you can use the following:

```puppet
  class { 'asterisk::language':
    language      => 'fr',
  }
```

Requirements
------------

In order to use this module, you need the augeasprovider for shellvar.

see https://github.com/hercules-team/augeasproviders for details.

Types
-----
    Note: The loading of the folloging types will also create the corresponding config Files.

  * asterisk::context::extensions

    ```puppet
    asterisk::context::extensions { "incoming":
      ensure => present,
      source => "...",
    }

    asterisk::context::extensions { "incoming":
      ensure  => present,
      content => template(...),
    }

    asterisk::context::extensions { "incoming":
      ensure => absent,
    }
    ```

  * asterisk::context::sip

    ```puppet
    asterisk::context::sip { "1234":
      ensure  => present,
      secret  => 'blah',
      context => 'incoming',
    }

    asterisk::context::sip { "1234":
      ensure => absent,
    }
    ```

    You can also use the 'template_name' argument to either define a template,
    by giving it a value of '!', or inherit from a template:

    ```puppet
    asterisk::context::sip { "corporate_user":
      context => 'corporate',
      type => 'friend',
      # ...
      template_name => '!',
    }
    asterisk::context::sip { "hakim":
      secret => 'ohnoes!',
      template_name => 'corporate_user',
    }
    ```

  * asterisk::registry::sip

    ```puppet
    asterisk::registry::sip { 'providerX':
      server => 'sip.providerX.com',
      user => 'doyoufindme',
    }
    ```

    Password, authuser, port number and extension are optional parameters. If
    you define authuser, you must specify a password.

    ```puppet
    asterisk::registry::sip { 'friends_home':
      server => 'home.friend.com',
      port => '8888',
      user => 'me',
      password => 'myselfandI',
      authuser => 'you',
      extension => 'whatsupfriend',
    }
    ```

  * asterisk::context::iax

    This class works similarly to the asterisk::context::extensions class.

    ```puppet
    asterisk::context::iax { '5551234567':
      source => 'puppet:///modules/site-asterisk/5551234567',
    }
    ```

  * asterisk::registry::iax

    ```puppet
    asterisk::registry::iax { 'providerX':
      server => 'iax.providerX.com',
      user => 'doyoufindme',
      pass => 'attractive?',
    }
    ```

  * asterisk::context::voicemail

    ```puppet
    asterisk::context::voicemail { "3000":
      context => 'some_context',
      password => '5555',
      user_name => 'Bob Bobby',
      email => 'bob@bobby.comcom',
    }
    ```

    You can also use the optional 'pager_email' to set the email that should
    receive a page about new voice messages.

    And finally, the argument 'options' can take a hash of voicemail options
    like the following:

    ```puppet
    asterisk::context::voicemail { "3001":
      context => 'blah',
      password => '112233',
      options => { 'attach' => 'yes', 'delete' => 'yes' },
    }

  * `asterisk::context::manager`
    
    ```puppet
    asterisk::context::manager { "nagios":
      permit => '127.0.0.1/255.255.255.255',
      secret => 'topsecret1234',
      read => 'all',
      write => 'system, call, log, verbose, command, agent, user',
    }
    ```

    paranoid configuration, with minimal network access, but the option to run system commands and trigger calls

    ```puppet
    asterisk::context::manager { "nagios":
      permit => '127.0.0.1/255.255.255.255',
      secret => 'topsecret1234',
      read => 'system,call',
      write => 'system,call',
    }
    ```

IAX2 Options
------------

If you are using the IAX2 protocol, you'll want to set some global
configuration options. The default values are taken from Debian's default
iax.conf file.

For passing in settings, you need to send a hash to the `asterisk::iax` class with
the `iax_options` parameter:

    $iax_options = {
        autokill => 'yes',
        jitterbuffer => 'no',
        forcejitterbuffer => 'no',
    }
    class { 'asterisk::iax':
        iax_options => $iax_options,
    }

One thing to watch out for, is that when you are giving a hash to the
`asterisk::iax` class, all the default values are not present anymore! So, you need
to define values for all of those that you are not overriding. Here is the
default hash with the default values, as defined in params.pp:

    $iax_options = {
      disallow => ['lpc10'],
      allow => ['gsm'],
      delayreject => 'yes',
      bandwidth => 'high',
      jitterbuffer => 'yes',
      forcejitterbuffer => 'yes',
      maxjitterbuffer => '1000',
      maxjitterinterps => '10',
      resyncthreshold => '1000',
      trunktimestamps => 'yes',
      autokill => 'yes',
    }

Here is a complete list of all available options:

  * bindport: Bind Asterisk to this port. If you are binding to multiple
    addresses, you can specify the port for each interface in bindaddr (see
    below).

  * bindaddr: Make asterisk listen on the following IP addresses (can be used
    more than once). To specify the port on which an address should listen, add
    it after the address and a colon (e.g. '192.168.0.100:5554').

  * iaxcompat: Useful when you use layered switches.

  * nochecksums: Disable UDP checksums.

  * delayreject: Delay the sending of authentication reject to alleviate brute
    force attacks on passwords.

  * amaflags: Default AMA flag. It must be one of 'default', 'omit', 'billing',
    or 'documentation'.

  * adsi: Enable ADSI-compatible equipment.

  * srvlookup: Perform an SRV lookup on outbound calls.

  * accountcode: Default account for CDR.

  * language: Global default language for users.

  * mohinterpret: Default, preferred music on hold channel.

  * mohsuggest: Defaul, suggested music on hold channel.

  * bandwidth: Specify bandwidth of low, medium, or high to control which
    codecs are used in general.

  * disallow: Array of codec names to prevent Asterisk from using with IAX2.

  * allow: Array of codec names to allow Asterisk to use with IAX2.

  * jitterbuffer: Global default for enabling/disabling the jitter buffer (can
    be set per-user).

  * forcejitterbuffer: Force the use of the jitter buffer even if the other end
    has a poorly performing jitter buffer.

  * dropcount: Maximum number of frames to overlook (e.g. consider "too late")
    inside the last 2 seconds.

  * maxjitterbuffer: Maximum size for the jitter buffer.

  * resyncthreshold: Number of frames over twice the measured jitter after
    which a resync is performed.

  * maxjitterinterps: The maximum number of interpolation frames the
    jitterbuffer should return in a row.

  * maxexcessbuffer: Maximum size by which the jitter buffer can be over what
    is needed. After a period of high jitter, Asterisk will gradually lower the
    buffer to follow this maximum.

  * minexcessbuffer: Minimum amount of unused buffer.

  * jittershrinkrate: Number of millisecs by which to shrink the jitter buffer
    for each 20ms when buffer is too big.

  * minregexpire: Minimum amount of time (seconds) that can be requested as a
    registration expriation interval.

  * maxregexpire: Maximum amount of time (seconds) that can be requested as a
    registration expriation interval.

  * encryption: Enable IAX2 encryption.

  * forceencryption: Refuse to connect unencrypted.

  * trunkmaxsize: Maximum payload in bytes an IAX2 trunk can support at a given
    time.

  * trunkmtu: Maximum transmission unit for IAX2 UDP trunking.

  * trunkfreq: How frequently trunk messages are sent in milliseconds.

  * trunktimestamps: Whether to send timestamps for the individual sub-frames
    within trunk frames or not.

  * iaxthreadcount: Number of iax helper threads to handle I/O.

  * iaxmaxthreadcount: Number of extra dynamic threads that may be spawned.

  * authdebug: disable authentication debugging to reduce the amount of
    debugging traffic.

  * tos / cos: Settings for Quality of service. See Asterisk documentation in
    /usr/share/doc/asterisk-doc/asterisk.pdf.gz (from package asterisk-doc).

  * regcontext: dynamically created and destroyed NoOp priority 1 extension for
    a given peer who registers or unregisters with Asterisk.

  * autokill: Cancel transaction if we don't get ACK to our NEW within 2000ms.

  * codecpriority: Control the codec negotiation of an inbound IAX call.

  * allowfwdownload: serve out firmware to IAX clients which request it.

  * rtcachefriends: Cache realtime friends by adding them to the internal list.

  * rtupdate: Whether or not to send registry updates to database using
    realtime.

  * rtautoclear: Auto-Expire friends created on the fly on the same schedule as
    if it had just registered.

  * rtignoreregexpire: use the stored address information regardless of whether
    the peer's registration has expired.

  * parkinglot: Default parkinglot for IAX peers and users.

  * calltokenoptional: Set call token validation as optional.

  * requirecalltoken: Global setting for call token verification. Can be set to
    'no', 'auto', or 'yes'.

  * maxcallnumbers: Maximum amount of call numbers per IP before refusing new
    connections.

  * maxcallnumbers\_nonvalidated: Global maximum amount of call numbers before
    refusing new connections.

SIP Options
------------

If you are using the SIP protocol, you'll want to set some global
configuration options. The default values are taken from Debian's default
sip.conf file.

For passing in settings, you need to send a hash to the `asterisk::sip` class with
the `sip_options` parameter:

    $sip_options = {
   	  disallow => ['all'],
      allow => ['alaw'],
      udpbindaddr => '10.1.1.30',
      nat => 'yes',
      language => 'fr',
      t38pt_udptl => 'yes',
    }
    class { 'asterisk::sip':
        sip_options => $sip_options,
    }

One thing to watch out for, is that when you are giving a hash to the
`asterisk::sip` class, all the default values are not present anymore! So, you need
to define values for all of those that you are not overriding. Here is the
default hash with the default values, as defined in params.pp:

  $sip_options = {
    disallow          => ['all'],
    allow             => ['alaw'],
    context           => 'inbound',
    allowguest        => 'no',
    allowoverlap      => 'no',
    udpbindaddr       => '0.0.0.0',
    tcpenable         => 'no',
    tcpbindaddr       => '0.0.0.0',
    srvlookup         => 'yes',
  }

Here a complete list of all available options, could be added.


Still not implemented !
-----------------------

Types:

  * `asterisk::queue`
  * `asterisk::sip`
  * `asterisk::mwi`  

