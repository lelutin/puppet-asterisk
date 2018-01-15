Puppet module for Asterisk
==========================

To install Asterisk on a server, simply use the following:

```puppet
include asterisk
```

This will install a plain version of Asterisk without any extra
features enabled.

Users that are upgrading (e.g. switching or merging to current master) should
consult the section named [Upgrade notices](#upgrade-notices) near the end.

Requirements
------------

In order to use this module, you need the stdlib module from:

https://github.com/puppetlabs/puppetlabs-stdlib

You should also make sure that augeas is installed since it is used to enable
the service in `/etc/default/asterisk`.

Reference reading
-----------------

Some good references to consult when it comes to Asterisk configuration are:

 * Online version of "Asterisk: The Definitive Guide" 3rd edition. This is
   definitely the best and most up to date documentation available. A must
   read for anyone that is configuring a PBX with Asterisk. Consult this
   reference if you need more information about any options that can be
   configured with this module. The web site mentions a 4th edition was
   released but it is not available online: http://asteriskdocs.org/
 * A good reference for VoIP and Asterisk (some information might be outdated):
   http://www.voip-info.org/
 * The Asterisk project wiki: https://wiki.asterisk.org/

Configuring Asterisk
====================

Parameters to the asterisk class
--------------------------------

The main class has a couple of parameters that determine what is managed and
how general configuration is set.

  * `$manage_service` is a boolean that determines whether puppet will ensure
    that the service is running. Default value is true.

  * `$manage_package` is a boolean that determines whether puppet will ensure
    that the package is installed. Default value is true.

  * `$package_name` can be used to override the name of the package that
    installs Asterisk. Default value is "asterisk".

  * `$service_name` can be used to override the name of the Asterisk service.
    Default value is "asterisk".

  * `$confdir` can be used to override the path to the Asterisk configuration.
    Default value is "/etc/asterisk".

  * `$iax_options` is a hash of global options for IAX2. See section IAX2
    Options.

  * `$sip_options` is a hash of global options for SIP. See section SIP Options.

  * `$voicemail_options` is a hash of global options for voicemail. See section
    Voicemail Options.

  * `$extensions_options` is a hash of global options for extensions. See
    section Extensions Options.

  * `$agents_multiplelogin` and `$agents_options` are detailed in the Agents
    Options section.

  * `$features_options` and `$featuremap` are detailed in the Features Options
    section.

  * `$queues_options` is detailed in the Queues Options section.

  * `$http_options` is detailed in the Asterisk Built-in HTTP Server section.

  * `$modules_autoload`, `$modules_noload`, `$modules_load` and
    `$modules_global_options` are detailed in the Modules section.

  * `$manager_enable`, `$manager_port` and `$manager_bindaddr` are detailed in
    the Manager Options section.

### Setting options with the $xyz_options parameters ###

Asterisk has lots and lots of configuration variables that can be set in
different files.

As you will see in some of the following configuration sections, some
configuration files will be customizable through option hashes. The format of
those hashes is always the same and looks like the following, where xyz would
match the name of the configuration file:

```puppet
$xyz_options = {
  'configuration-option1' => 'value1',
  'allow'                 => ['list-value1', 'list-value2'],
  #[...]
}
```

In order to simplify the module, we're actually not validating that the options
passed in are valid ones and expect this validation to be done by the user.

We encourage users to use strings as hash keys as in the example above since
some Asterisk options have dashes in their name and dashes are prohibited in
puppet DSL symbols.

Some options should always be arrays: the option can be specified in the
configuration file more than once to declare more values. Those options will
always be set in the hashes that define default values (see in each section
below) as arrays either containing a number of strings, or being empty. The
module enforces that those options be arrays since it needs to iterate over them
in templates. Empty arrays mean that the option should not appear in the
configuration file.

Default values are taken from Debian's default configuration files.

Keys that are present in the option hash paramters to the `asterisk` class will
override the default options (or set new ones for options that are not present
in the default option hash). This lets you use all the default values but
change only a couple of values.

Source or content
-----------------

Most of the defined types that drop a configuration file in a .d directory can
either take a puppet source specification (of the form 'puppet:///modules/...'
or a textual content.

The puppet source specification is always used with the `source` parameter and
textual content with the `content` parameter.

When using a puppet source specification the user has complete control over the
contents of the configuration file. When textual content is used, the contents
will usually be added after a line that defines a configuration section (e.g. a
line of the form '[section]').

`source` and `content` are always mutually exclusive.

IAX2
----

The `asterisk::iax` defined type helps you configure an IAX2 channel. `source`
or `content` can be used with this type.

```puppet
asterisk::iax { '5551234567':
  source => 'puppet:///modules/site_asterisk/5551234567',
}
```

The `asterisk::registry::iax` defined type is used to configure an IAX2
registry. All parameters (except for ensure) are mandatory. For example:

```puppet
asterisk::registry::iax { 'providerX':
  server => 'iax.providerX.com',
  user   => 'doyoufindme',
  pass   => 'attractive?',
}
```

### IAX2 Options ###

If you are using the IAX2 protocol, you'll want to set some global
configuration options. For passing in settings, you need to send a hash to the
`asterisk` class with the `iax_options` parameter.

Here is the default hash with the default values, as defined in params.pp:

```puppet
$iax_options = {
  'allow'             => [],
  'disallow'          => ['lpc10'],
  'bandwidth'         => 'low',
  'jitterbuffer'      => 'no',
  'forcejitterbuffer' => 'no',
  'autokill'          => 'yes',
  'delayreject'       => 'yes',
}
```

SIP
---

You can configure SIP channels with the `asterisk::sip` defined type. `source`
and `content` can be used with this type.

```puppet
asterisk::sip { '1234':
  ensure  => present,
  secret  => 'blah',
  context => 'incoming',
}
```

You can also use the `template_name` argument to either define a template, or
make the channel definition inherit from a template.

To define a template, set `template_name` to '!':

```puppet
asterisk::sip { 'corporate_user':
  context       => 'corporate',
  type          => 'friend',
  # ...
  template_name => '!',
}
```

If inheriting from a template, set `template_name` to
the name of the template from which the channel is inheriting options.

```puppet
asterisk::sip { 'hakim':
  secret        => 'ohnoes!',
  template_name => 'corporate_user',
}
```

The defined type `asterisk::registry::sip` lets you configure a SIP registry.
The `server` and `user` paramters are mandatory.

```puppet
asterisk::registry::sip { 'providerX':
  server => 'sip.providerX.com',
  user   => 'doyoufindme',
}
```

Password, authuser, port number and extension are optional parameters. If you
define authuser, you must specify a password.

```puppet
asterisk::registry::sip { 'friends_home':
  server    => 'home.friend.com',
  port      => '8888',
  user      => 'me',
  password  => 'myselfandI',
  authuser  => 'you',
  extension => 'whatsupfriend',
}
```


### SIP Options ###

If you are using the SIP protocol, you'll want to set some global
configuration options. For passing in settings, you need to send a hash to the
`asterisk` class with the `sip_options` parameter.

Here is the default hash with the default values, as defined in params.pp:

```puppet
$sip_options = {
  'disallow'         => [],
  'allow'            => [],
  'domain'           => [],
  'localnet'         => [],
  'context'          => 'default',
  'allowoverlap'     => 'no',
  'udpbindaddr'      => '0.0.0.0',
  'tcpenable'        => 'no',
  'tcpbindaddr'      => '0.0.0.0',
  'transport'        => 'udp',
  'srvlookup'        => 'yes',
  'allowguest'       => 'no',
  'alwaysauthreject' => 'yes',
}
```

### SIP encryption ###

If you want to enable SIP encryption, you can set the following settings in the
`sip_options` parameter to the `asterisk` class:

```puppet
$sip_option = {
  'transports'          => ['tls'],
  'encryption'          => 'yes',
  'tlsenable'           => 'yes',
  # Change the following two values to the full paths where you're placing your
  # own certificat and CA files, respectively.
  'tlscertfile'         => '/etc/ssl/somecert.crt',
  'tlscafile'           => '/etc/ssl/someca.crt',
  # Only set this to 'yes' if you can't possibly get a verifiable certificate.
  'tlsdontverifyserver' => 'no',
}
```

Note: the 'transports' option needs to be an array, so even though you only
enable 'tls' as a transport, you need to enclose the string inside an array.

Voicemail
---------

With the defined type `asterisk::voicemail` you can configure a voicemail. The
`context` and `password` parameters are mandatory:

```puppet
asterisk::voicemail { '3000':
  context   => 'some_context',
  password  => '5555',
  user_name => 'Bob Bobby',
  email     => 'bob@bobby.comcom',
}
```

You can also use the optional 'pager_email' parameter to set the email that
should receive a page about new voice messages.

And finally, the argument 'options' can take a hash of voicemail options like
the following:

```puppet
asterisk::voicemail { '3001':
  context  => 'blah',
  password => '112233',
  options  => { 'attach' => 'yes', 'delete' => 'yes' },
}
```

### Voicemail Options ###

Voicemail can be configured through a set of options in the `[general]`
context. To set those options, you can pass values as a hash to the
`voicemail_options` parameter to the main class.

Here is the default hash with the default values, as defined in params.pp:

```puppet
$voicemail_options = {
  'format'           => 'wav49|gsm|wav',
  'serveremail'      => 'asterisk',
  'attach'           => 'yes',
  'skipms'           => 3000,
  'maxsilence'       => 10,
  'silencethreshold' => 128,
  'maxlogins'        => 3,
  # This is not really the default value for emailbody but it makes more
  # sense to be a bit more verbose by default.
  'emailbody'        => 'Dear ${VM_NAME}:\n\n\tjust wanted to let you know you were just ${IF($["${VM_CIDNUM}" = "${ORIG_VM_CIDNUM}"]?left:forwarded)} a ${VM_DUR} long message (number ${VM_MSGNUM})\nin mailbox ${VM_MAILBOX} from ${VM_CALLERID} <${VM_CIDNUM}>, on ${VM_DATE},\n${IF($["${VM_CIDNUM}" = "${ORIG_VM_CIDNUM}"]?so:(originally sent by ${ORIG_VM_CALLERID} on ${ORIG_VM_DATE})\nso)} you might want to check it when you get a chance.  Thanks!\n\n\t\t\t\t--Asterisk\n',
  'emaildateformat'  => '%A, %B %d, %Y at %r',
  'pagerdateformat'  => '%A, %B %d, %Y at %r',
  'sendvoicemail'    => 'yes',
}
```

Extensions
----------

Extensions can be set with the `asterisk::extensions` defined type. `source` or
`content` can be used with this type.

```puppet
asterisk::extensions { 'incoming':
  ensure  => present,
  content => template('site_asterisk/extensions/incoming.erb'),
}
```

### Extensions Options ###

Some global options can be set for extensions. You can achieve that by passing
a hash to the `extensions_options` parameter to the `asterisk` class.

Here is the default hash with the default values, as defined in params.pp:

```puppet
$extensions_options = {
  'static'          => 'yes',
  'writeprotect'    => 'no',
  'clearglobalvars' => 'no',
}
```

Note that by default no global variables (e.g. values set in the `[globals]`
context) are set. To set global variables, you can use an
`asterisk::extensions` resource with a context value of "globals".

Agents
------

To define an agent you can use the `asterisk::agent` defined type. The `ext`,
`password` and `agent_name` parameters are mandatory.

To define a static agent:

```puppet
asterisk::agent { 'joe':
  ext        => '1001',
  password   => '123413425',
  agent_name => 'Joe Bonham',
}
```

You can also assign a static agent to one or more agent groups with the
`groups` parameter. This parameter is a list of group names:

```puppet
asterisk::agent { 'cindy':
  ext        => '1002',
  password   => '754326',
  agent_name => 'Cindy Rotterbauer',
  groups     => ['1']
}
```

Static agents have some disadvantages compared to dynamic agents. For example,
once assigned to a queue they cannot logout of that queue. For more information
on how to setup dynamic agents, see:

 * [http://www.voip-info.org/wiki/view/Asterisk+cmd+AgentLogin](http://www.voip-info.org/wiki/view/Asterisk+cmd+AgentLogin)
 * [http://www.voip-info.org/wiki/view/Asterisk+cmd+AddQueueMember](http://www.voip-info.org/wiki/view/Asterisk+cmd+AddQueueMember)
 * [http://www.voip-info.org/wiki/view/Asterisk+cmd+RemoveQueueMember](http://www.voip-info.org/wiki/view/Asterisk+cmd+RemoveQueueMember)

### Agents Options ###

Some global options can be set for agents. One option in the `[general]`
context, `multiplelogin`, can be set via the `agents_multiplelogin` parameter
to the `asterisk class` with a boolean value.

Global options in the `[agents]` context can be set by passing a hash to the
`agents_options` parameter to the `asterisk` class. By default this parameter
doesn't define any global options.

For creating agents, it is recommended to use the `asterisk::agent` defined
type.

Features
--------

Features let you configure call parking and special numbers that trigger
special functionality. The `asterisk::feature` defined type helps you
configuring such features. The `options` parameter is mandatory.

Define features that are contained within feature group "myfeaturegroup":

```puppet
$ft_options = {
  'pausemonitor'   => '#1,self/callee,Pausemonitor',
  'unpauseMonitor' => '#3,self/callee,UnPauseMonitor',
}
asterisk::feature { 'myfeaturegroup':
  options => $ft_options,
}
```

A special section in the features configuration file, namely
`[applicationmaps]` lets you define global features. The
`asterisk::feature::applicationmap` defined type helps you configure such a
global feature. The `feature` and `value` parameters are mandatory:

```puppet
asterisk::feature::applicationmap { 'pausemonitor':
  feature => 'pausemonitor',
  value   => '#1,self/callee,Pausemonitor',
}
```

### Features Options ###

Some global feature options can be configured, like the default parkinglot, via
the `features_options` parameter to the `asterisk` class.

Here is the default hash with the default values, as defined in params.pp:

```puppet
$features_options = {
  'parkext' => '700',
  'parkpos' => '701-720',
  'context' => 'parkedcalls',
}
```

A special context, `featuremap`, lets you configure global features. By
default, no feature is configured. You can pass a hash to the
`features_featuremap` parameter to the `asterisk` class to configure features
in this context.

Another special context, `applicationmap`, lets you configure dynamic features.
To set entries in this context, you should use the
`asterisk::feature::applicationmap` defined type. Note also that for dynamic
features to work the DYNAMIC_FEATURES channel variable must be set by listing
features enabled in the channel, separated by '#'.

To configure additional feature contexts, you can use the `asterisk::feature`
defined type.

Queues
------

Asterisk can put call in queues, for example when all agents are busy and the call cannot get connected. To create a queue, you can use the `asterisk::queue` defined type:

```puppet
asterisk::queue { 'frontline':
  ensure   => present,
  stragegy => 'rrmemory',
  members  => [
    'SIP/reception',
    'SIP/secretary',
  ],
  maxlen   => 30,
  timeout  => 20,
  retry    => 10,
}
```

Call queues have lots of options and can interact with agents. Because of this
we will not detail all of the parameters here. Please refer to the
manifests/queue.pp file for the complete list of supported parameters. Also,
for an in-depth coverage of call queueing, see:
http://www.asteriskdocs.org/en/3rd_Edition/asterisk-book-html-chunk/asterisk-ACD.html

### Queues Options ###

For queues some global configurations and default values can be set in the
`[general]` context. You can set options by passing a hash to the
`queues_options` parameter to the `asterisk` class.

Here is the default hash with the default values, as defined in params.pp:

```puppet
$queues_options = {
  'persistentmembers' => 'yes',
  'monitor-type'      => 'MixMonitor',
}
```

Asterisk Built-in HTTP Server
------

The core of Asterisk provides a basic HTTP/HTTPS server. To enable the server, you can use the `asterisk::http_options` parameter. For passing in settings, you need to send a hash to the asterisk class with the http_options parameter.

Here is the default hash with the default values, as defined in params.pp::

```puppet
  $http_options = {
    'bindaddr'            => '127.0.0.1',
    'enabled'             => 'yes',
    'bindport'            => 8080,
    'prefix'              => 'asterisk',
    'sessionlimit'        => 100,
    'session_inactivity'  => 30000,
    'session_keep_alive' => '15000',
    'enablestatic'        => 'yes',
  }
```

See:
https://wiki.asterisk.org/wiki/display/AST/Asterisk+Builtin+mini-HTTP+Server

Modules
-------

Configuring Asterisk modules is key to implementing your features right. Four
parameter to the `asterisk` class offer you the possibility to customize what
modules are loaded or not on your PBX. Default values for the parameters were
taken from the default config file in Debian.

 * `modules_autoload`: a boolean value (defaults to `true`) that decides
   whether or not Asterisk will try to automatically load required modules even
   though they are not explicitely marked as needing to be loaded in the
   modules.conf file.

 * `modules_noload`: an array of strings of explicitely unwanted modules that
   won't load even though `modules_autoload` is true. Specifying an array to
   this parameter overrides the default list so make sure to include all
   unwanted modules. The default array is the following:

   ```puppet
   $modules_noload = [
     'pbx_gtkconsole.so',
     'pbx_kdeconsole.so',
     'app_intercom.so',
     'chan_modem.so',
     'chan_modem_aopen.so',
     'chan_modem_bestdata.so',
     'chan_modem_i4l.so',
     'chan_capi.so',
     'chan_alsa.so',
     'cdr_sqlite.so',
     'app_directory_odbc.so',
     'res_config_odbc.so',
     'res_config_pgsql.so'
   ]
   ```

 * `modules_load`: an array of strings of explicitely wanted modules.
   Specifying an array to this parameter overrides the default list so make
   sure to include all wanted modules. The default array is the following:

   ```puppet
   $modules_load = ['res_musiconhold.so']
   ```

 * `modules_global_options`: a hash of options that should be set in the
   `[global]` context. These options let you customize behaviours for modules
   that are loaded.

Managers
--------

Asterisk can expose an interface for managing the PBX. This interface can be
offered to different users with different permissions. You can configure read
and write access to certain features of the PBX for each user.

The `asterisk::manager` defined type helps you configure a manager access. The
`secret` parameter is mandatory. By default, the resource name is used as the
manager name:

```puppet
asterisk::manager { 'nagios':
  secret => 'topsecret1234',
  read   => ['all'],
  write  => ['system', ' call', ' log', ' verbose', ' command', ' agent', ' user'],
}
```

Here's a paranoid version of the above configuration, with minimal network
access, but the option to run system commands and trigger calls:

```puppet
asterisk::manager { 'nagios':
  secret => 'topsecret1234',
  read   => ['system', 'call'],
  write  => ['system', 'call'],
}
```

Here, we permit remote management to two other systems on an internal network:

```puppet
asterisk::manager { 'robocall':
  secret => 'robotsdeservesomeloveafterall',
  permit => ['10.10.10.200/255.255.255.0', '10.20.20.200/255.255.255.0'],
  read   => ['system', 'call', 'log'],
  write  => ['system', 'call', 'originate'],
}
```

To override the manager name, you can use the `manager_name` parameter:

```puppet
asterisk::manager { 'sysadmin':
  secret       => 'nowyouseemenowyoudont',
  read         => ['all'],
  write        => ['all'],
  manager_name => 'surreptitioustyrant',
}
```

### Manager Options ###

Asterisk maintains a service on a port through which you can inspect asterisk's
state and issue commands to the PBX. You can control on which IP and port it
binds to and if it is enabled at all with three parameters to the `asterisk`
class.

 * `manager_enable`: a boolean value that decides whether or not the manager is
   in function. Defaults to true.

 * `manager_port`: an integer value that specifies on which port the manager
   will listen. Default value is 5038.

 * `manager_bindaddr`: a string that contains the IP address on which the
   manager should bind. Default value is 127.0.0.1.

By default, no user access is configured. If you want to enable users to
interact with the manager, you should declare `asterisk::manager`
resources.

Dahdi
-----

Dahdi is a set of kernel modules combined with an asterisk module that let
people interact with Digium cards to send and receive calls from the POTS. To
enable dahdi, use the following:

```puppet
  include 'asterisk::dahdi'
```

Language sounds
---------------

To include any language sounds, you can use the following (in this example,
we're installing french and spanish sounds):

```puppet
  asterisk::language {
    ['fr-armelle', 'es']:
  }
```

Valid languages strings are the following (these are all based on debian
package names for now -- either asterisk-prompt-X or asterisk-Y. the language
strings that start with core-sounds enable you to install language sounds in a
specific encoding to avoid the need for asterisk to recode it while feeding it
to a device):

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
 * core-sounds-en
 * core-sounds-en-g722
 * core-sounds-en-gsm
 * core-sounds-en-wav
 * core-sounds-es
 * core-sounds-es-g722
 * core-sounds-es-gsm
 * core-sounds-es-wav
 * core-sounds-fr
 * core-sounds-fr-g722
 * core-sounds-fr-gsm
 * core-sounds-fr-wav
 * core-sounds-ru
 * core-sounds-ru-g722
 * core-sounds-ru-gsm
 * core-sounds-ru-wav

Upgrade notices
===============

 * The module used to manage files under /etc/asterisk/file.conf.d
   for all values of "file" that were managed. Things have been moved to
   /etc/asterisk/file.d, so before upgrading you should remove all .conf.d
   directories (all files under the old dirs will be automatically recreated in
   the new directories).

 * The defines that were previously named asterisk::context::xyz (or
   transitorily asterisk::snippet::xyz) are now named asterisk::xyz. Users will
   need to adjust their manifests to upgrade.

 * The `queues_monitor_type` and `queues_monitor_format` parameters to the
   default class were removed in favor of using quoted strings in the options
   array. Users who used those two options need to place their values in the
   `$queues_options` hash with 'monitor-type' and 'monitor-format' strings as
   keys, respectively. To ensure that 'monitor-type' is not present in the
   config file, simply leave it out (as opposed to the previous behaviour of
   the option that required an empty string for this).

 * Some default values were removed and some others were modified to be closer
   to default Debian config files. You should verify that new values or
   variables that disappear won't have an impact on your setup.

Patches and Testing
===================

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


Still not implemented !
-----------------------

Types:

  * `asterisk::mwi`

License
=======

This module is licensed under the GPLv3+, feel free to redistribute, modify and
contribute changes.

A copy of the GPLv3 license text should be included with the module. If not,
check out the github repository at https://github.com/lelutin/puppet-asterisk
or one of its clones.

The license text can also be downloaded from:

https://www.gnu.org/licenses/gpl-3.0.txt

