# @summary Install and configure an asterisk server.
#
# @example simple install
#   class { 'asterisk': }
#
# @see http://www.asteriskdocs.org/en/3rd_Edition/asterisk-book-html-chunk/ACD_id288901.html#options_general_queues_id001 General queues options
#
# @todo make it possible to manage dialplan with the two other methods (e.g.
#   AEL and Lua)
# @todo overhaul README file before release. lots of things have changed
#
# @param manage_service
#   Set this to false to avoid managing the asterisk service. By default puppet
#   will enable the service and ensure that it is running.
# @param manage_package
#   Set this to false to avoid installing the asterisk package.
# @param package_name
#   Name or array of the package(s) being installed for asterisk.
# @param service_name
#   Name of the asterisk service.
# @param confdir
#   Absolute path to the asterisk configuration directory.
# @param purge_confdir
#   Set this to true to enable autoremoval of configuration files that are
#   not managed by puppet inside of asterisk's `confdir`.
#
# @param iax_general
#   Global configurations for IAX2. Options are set in the file as `key =
#   value` in the `[general]` section of `iax.conf`.
# @param iax_contexts
#   Hash of resource_name => params used to instantiate `asterisk::iax`
#   defined types.
# @param iax_registries
#   Hash of resource_name => params used to instantiate
#   `asterisk::registry::iax` defined types.
# @param sip_general
#   Global configurations for SIP. Options are set in the file as `key = value`
#   in the `[general]` section of the `sip.conf` file.
# @param sip_peers
#   Hash of resource_name => params used to instantiate `asterisk::sip`
#   defined types.
# @param sip_registries
#   Hash of resource_name => params used to instantiate
#   `asterisk::registry::sip` defined types.
# @param voicemail_general
#   Global configurations for voicemail. Options are set in the file as `key =
#   value` in the `[general]` section of the `voicemail.conf` file.
# @param voicemails
#   Hash of resource_name => params used to instantiate `asterisk::voicemail`
#   defined types.
# @param extensions_general
#   Global configurations for the dialplan. Options are set in the file as `key
#   = value` in the `[general]` section of the `extensions.conf` file.
# @param extensions_globals
#   Hash of global variables for the dialplan, placed in the `[globals]`
#   section of the `extensions.conf` file.
#
#   WARNING: If you load any other extension configuration engine, such as
#   pbx_ael.so, your global variables may be overridden by that file. Please
#   take care to use only one location to set global variables, and you will
#   likely save yourself a ton of grief.
#
#   The variables defined here can be accessed throughout the dialplan with the
#   `GLOBAL()` function. Global variables can make dialplans reusable by
#   different servers with different use cases.
#
#   They also make dialplans easier to maintain by concentrating certain
#   information in one location (e.g. to avoid having to modify the same value
#   through many contexts and macros).
#
#   Global variables can also be used for hiding passwords from Asterisk logs,
#   for example for `register` lines or calls to `Dial()` where information
#   about the provider is combined with username and password: when using a
#   global variable, the variable name will be shown in logs, not the actual
#   password.
#
#   Variables are set in the file as `key=value`. If you pass in a Sensitive
#   type as the value, it will be unwrapped for outputting in the configuration
#   file: this can avoid showing certain sensitive information (as passwords)
#   in puppet logs.
# @param extension_contexts
#   Hash of resource_name => params used to instantiate `asterisk::extension`
#   defined types.
# @param agents_global
#   Global configurations for agents. Options are set in the file as `key =
#   value` in the `[agents]` section of the `agents.conf` file.
# @param agents
#   Hash of resource_name => params used to instantiate `asterisk::agent`
#   defined types.
# @param features_general
#   Global call features. Options are set in the file as `key = value` in the
#   `[general]` section of `features.conf`.
# @param features_featuremap
#   Global feature maps. Options are set in the file as `key => value` in the
#   `[featuremap]` section of `features.conf`.
# @param features_applicationmap
#   Global application feature maps. Options are set in the file as
#   `key => value` in the `[applicationmap]` section of `features.conf`.
# @param features
#   Hash of resource_name => params used to instantiate `asterisk::feature`
#   defined types.
# @param logger_general
#   Global configurations for asterisk logging. Options are set in the file as
#   `key=value` in the `[general]` section of `logger.conf`.
# @param log_files
#   A hash defining log files.
#
#   Top-level keys set log file names.
#
#   Log files can use the special names `console` or `syslog` to determine
#   what output is sent to the asterisk CLI console and syslog, respectively.
#
#   All other top-level keys represent a file name. File names can
#   be either relative to the `asterisk.conf` setting `astlogdir` or an
#   absolute path.
#
#   Values associated to the top-level keys should be a hash that
#   contains at least one key, `levels`. The value for `levels` should be an
#   array listing logging levels for this log file.
#
#   As well as `levels`, there can be an optional key, `formatter`. Its value
#   should be a string containing either `default` or `json` and it defines
#   which format will be output to the log. If the `formatter` key is
#   omitted, asterisk's default log format is used.
# @param queues_general
#   Global configurations for queues. Options are set in the file as
#   `key => value` in the `[general]` section of the `queues.conf` file.
# @param queues
#   Hash of resource_name => params used to instantiate `asterisk::queue`
#   defined types.
# @param modules_autoload
#   Set this to false to avoid having asterisk load modules automatically on an
#   as-needed basis. This can be used to configure modules in a more
#   restrictive manner.
# @param modules_preload
#   List of modules that asterisk should load before asterisk core has been
#   initialized. This can be useful if you wish to map all module configuration
#   files into Realtime storage.
# @param modules_noload
#   List of modules that asterisk should not load. This can be useful if
#   `modules_autoload` is set to `true`.
# @param modules_load
#   List of modules that asterisk should load on startup. This is useful if
#   you've set `modules_autoload` to `false`.
# @param modules_global
#   Global configurations for modules. Options are set in the file as
#   `key => value` in the `[global]` section of the `modules.conf` file.
# @param manager_enable
#   Set this to false to disable asterisk manager.
# @param manager_port
#   Port number on which asterisk will listen to for manager connections.
#   Defaults to 5038.
# @param manager_bindaddr
#   IP address to have asterisk bind to for manager connections. Defaults to
#   binding to localhost.
# @param manager_accounts
#   Hash of resource_name => params used to instantiate `asterisk::manager`
#   defined types.
#
class asterisk (
  # Global management options
  Boolean                        $manage_service,
  Boolean                        $manage_package,
  Variant[String, Array[String]] $package_name,
  String                         $service_name,
  Stdlib::Absolutepath           $confdir,
  Boolean                        $purge_confdir,
  # Asterisk modules and applications
  Hash                           $iax_general,
  Stdlib::CreateResources        $iax_contexts,
  Stdlib::CreateResources        $iax_registries,
  Hash                           $sip_general,
  Stdlib::CreateResources        $sip_peers,
  Stdlib::CreateResources        $sip_registries,
  Hash                           $voicemail_general,
  Stdlib::CreateResources        $voicemails,
  Hash                           $extensions_general,
  Asterisk::ExtGlobalVars        $extensions_globals,
  Stdlib::CreateResources        $extension_contexts,
  Hash                           $agents_global,
  Stdlib::CreateResources        $agents,
  Asterisk::FeaturesGeneral      $features_general,
  Asterisk::Featuremap           $features_featuremap,
  Hash[String,String]            $features_applicationmap,
  Stdlib::CreateResources        $features,
  Hash[String,String]            $logger_general,
  Hash[String,Asterisk::Logfile] $log_files,
  Hash                           $queues_general,
  Stdlib::CreateResources        $queues,
  Boolean                        $modules_autoload,
  Array[String]                  $modules_preload,
  Array[String]                  $modules_noload,
  Array[String]                  $modules_load,
  Hash                           $modules_global,
  Boolean                        $manager_enable,
  Integer                        $manager_port,
  String                         $manager_bindaddr,
  Stdlib::CreateResources        $manager_accounts,
) {
  # We'll only ensure the type of some of the *_general on which templates
  # iterate. There's no complex data type that can let us be this flexible
  # (e.g. everything should be a string, but those handful of keys.
  assert_type(Array[String], $iax_general['allow'])
  assert_type(Array[String], $iax_general['disallow'])

  assert_type(Array[String], $sip_general['allow'])
  assert_type(Array[String], $sip_general['disallow'])
  assert_type(Array[String], $sip_general['domain'])
  assert_type(Array[String], $sip_general['localnet'])

  contain asterisk::install
  contain asterisk::config
  contain asterisk::service

  # create_resources:
  create_resources('asterisk::iax', $iax_contexts)
  create_resources('asterisk::registry::iax', $iax_registries)
  create_resources('asterisk::sip', $sip_peers)
  create_resources('asterisk::registry::sip', $sip_registries)
  create_resources('asterisk::voicemail', $voicemails)
  create_resources('asterisk::extension', $extension_contexts)
  create_resources('asterisk::agent', $agents)
  create_resources('asterisk::feature', $features)
  create_resources('asterisk::queue', $queues)
  create_resources('asterisk::manager', $manager_accounts)

  Class['asterisk::install']
  -> Class['asterisk::config']
  ~> Class['asterisk::service']
}
