Puppet module for Asterisk
==========================

To install Asterisk on a server, simply use the following:

  include asterisk

This will install a plain version of Asterisk without any extra
Futures enabled.

Requirements
------------

In order to use this module, you need the augeasprovider for shellvar.

see https://github.com/hercules-team/augeasproviders for details.

You also need the stdlib module from:

https://github.com/puppetlabs/puppetlabs-stdlib

Extra features
--------------

To enable dahdi, use the following:

```puppet
  include 'asterisk::dahdi'
```

To include any language sounds, you can use the following (in this example,
we're installing french and spanish sounds):

```puppet
  asterisk::language {
    ['fr-armelle', 'es']:
  }
```

Valid languages strings are the following:

 * de
 * es-co
 * fr-armelle
 * fr-proformatique
 * it-menardi
 * it-menardi-alaw
 * it-menardi-gsm
 * it-menardi-wav
 * se
 * es

Types
-----

  * `asterisk::context::extensions`

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

  * `asterisk::context::sip`

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

  * `asterisk::registry::sip`

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

  * `asterisk::context::iax`

    This class works similarly to the asterisk::context::extensions class.

    ```puppet
    asterisk::context::iax { '5551234567':
      source => 'puppet:///modules/site_asterisk/5551234567',
    }
    ```

  * `asterisk::registry::iax`

    ```puppet
    asterisk::registry::iax { 'providerX':
      server => 'iax.providerX.com',
      user => 'doyoufindme',
      pass => 'attractive?',
    }
    ```

  * `asterisk::context::voicemail`

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
    ```

  * `asterisk::context::manager`

    ```puppet
    asterisk::context::manager { "nagios":
      permit => '127.0.0.1/255.255.255.255',
      secret => 'topsecret1234',
      read => 'all',
      write => 'system, call, log, verbose, command, agent, user',
    }
    ```

    paranoid configuration, with minimal network access, but the option to run
    system commands and trigger calls:

    ```puppet
    asterisk::context::manager { "nagios":
      permit => '127.0.0.1/255.255.255.255',
      secret => 'topsecret1234',
      read => 'system,call',
      write => 'system,call',
    }
    ```

Patches and Testing
-------------------

Contributions are highly welcomed, more so are those which contribute patches
with tests. Or just more tests! We have
[rspec-puppet](http://rspec-puppet.com/) and
[rspec-system](https://github.com/puppetlabs/rspec-system-serverspec) tests.
When [contributing patches](Github WorkFlow), please make sure that your
patches pass tests:

    user@host01 ~/src/bw/puppet-composer (git)-[master] % rake spec
    ....................................

    Finished in 2.29 seconds
    36 examples, 0 failures
    user@host01 ~/src/bw/puppet-composer (git)-[master] % rake spec:system

    ...loads of output...
    2 examples, 0 failures
    user@host01 ~/src/bw/puppet-composer (git)-[master] %


IAX2 Options
------------

If you are using the IAX2 protocol, you'll want to set some global
configuration options. The default values are taken from Debian's default
iax.conf file.

For passing in settings, you need to send a hash to the `asterisk` class with
the `iax_options` parameter:

```puppet
$iax_options = {
    autokill => 'yes',
    jitterbuffer => 'no',
    forcejitterbuffer => 'no',
}
class { 'asterisk':
    iax_options => $iax_options,
}
```

Keys that are present in the `$iax_options` paramter to the asterisk class will
override the default options (or set new ones for options that are not present
in the default option hash). This lets you use all the default values but
change only a couple of values.

Here is the default hash with the default values, as defined in params.pp:

```puppet
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
```

See the [complete list](docs/iax.md) of all available options.

SIP Options
------------

If you are using the SIP protocol, you'll want to set some global
configuration options. The default values are taken from Debian's default
sip.conf file.

For passing in settings, you need to send a hash to the `asterisk` class with
the `sip_options` parameter:

```puppet
$sip_options = {
  disallow => ['all'],
  allow => ['alaw'],
  localnet => [],
  domain => [],
  udpbindaddr => '10.1.1.30',
  nat => 'yes',
  language => 'fr',
  t38pt_udptl => 'yes',
}
class { 'asterisk':
    sip_options => $sip_options,
}
```

Similarly to the SIP options, keys that are present in the `$sip_options`
paramter to the asterisk class will override the default options (or set new
ones for options that are not present in the default option hash). This lets
you use all the default values but change only a couple of values.

Here is the default hash with the default values, as defined in params.pp:

```puppet
$sip_options = {
  disallow     => ['all'],
  allow        => ['alaw'],
  localnet     => ['192.168.0.0/255.255.0.0','10.0.0.0/255.0.0.0','172.16.0.0/12'.'169.254.0.0/255.255.0.0'],
  domain       => [],
  context      => 'inbound',
  allowguest   => 'no',
  allowoverlap => 'no',
  udpbindaddr  => '0.0.0.0',
  tcpenable    => 'no',
  tcpbindaddr  => '0.0.0.0',
  srvlookup    => 'yes',
}
```

Here a complete list of all available options, should be added.

Voicemail Options
-----------------

Voicemail can be configured through a set of options in the `[general]`
context. To set those options, you can pass values as a hash to the
`voicemail_options` parameter to the main class. Default values are taken from
the default configuration file from Debian:

```puppet
$voicemail_options = {
  servermail      => 'telephone',
  format          => 'wav49|wav',
  emaildateformat => '%F, at %R:%S',
  delete          => 'yes',
}
class { 'asterisk':
  voicemail_options => $voicemail_options,
}
```

Again, keys that are present in the `voicemail_options` parameter to the
`asterisk` class will override the default options (or set new ones).

Here is the default hash with the default values, as defined in params.pp:

```puppet
$voicemail_options = {
  format           => 'wav49|gsm|wav',
  serveremail      => 'asterisk',
  attach           => 'yes',
  minsecs          => 3,
  skipms           => 3000,
  maxsilence       => 10,
  silencethreshold => 128,
  maxlogins        => 3,
  emailbody        => 'Dear ${VM_NAME}:\n\n\tjust wanted to let you know you were just ${IF($["${VM_CIDNUM}" = "${ORIG_VM_CIDNUM}"]?left:forwarded)} a ${V
  emaildateformat  => '%A, %B %d, %Y at %r',
  sendvoicemail    => 'yes',
}
```

Still not implemented !
-----------------------

Types:

  * `asterisk::context::queue`
  * `asterisk::mwi`

Templates:

  * voicemail.conf
  * modules.conf
  * extensions.conf
  * manager.conf
  * queues.conf

License
-------

This module is licensed under the GPLv3+, feel free to redistribute, modify and
contribute changes.

A copy of the GPLv3 license text should be included with the module. If not,
check out the github repository at https://github.com/lelutin/puppet-asterisk
or one of its clones.

The license text can also be downloaded from:

https://www.gnu.org/licenses/gpl-3.0.txt

