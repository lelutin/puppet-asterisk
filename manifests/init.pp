# @summary Install and configure an asterisk server.
#
# @example simple install
#   class { 'asterisk': }
#
# @see http://www.asteriskdocs.org/en/3rd_Edition/asterisk-book-html-chunk/ACD_id288901.html#options_general_queues_id001 General queues options
#
# @todo Purge unmanaged configs by default. Add parameter to disable purging.
# @todo Add hash-based params that can be used to create a set of resources
#   for each type with create_resource. This can be useful for pushing data out
#   to hiera.
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
#
# @param iax_general
#   Global configurations for IAX2. Options are set in the file as `key =
#   value` in the `[general]` section of `iax.conf`.
# @param sip_general
#   Global configurations for SIP. Options are set in the file as `key = value`
#   in the `[general]` section of the `sip.conf` file.
# @param voicemail_general
#   Global configurations for voicemail. Options are set in the file as `key =
#   value` in the `[general]` section of the `voicemail.conf` file.
# @param extensions_general
#   Global configurations for the dialplan. Options are set in the file as `key
#   = value` in the `[general]` section of the `extensions.conf` file.
# @param extensions_globals
#   Hash of global variables for the dialplan, placed in the `[globals]`
#   section of the `extensions.conf` file. The variables defined here can be
#   accessed throughout the dialplan with the `GLOBAL()` function. Global
#   variables can make dialplans reusable by different servers with different
#   use cases. They also make dialplans easier to maintain by concentrating
#   certain information in one location (e.g. to avoid having to modify the
#   same value through many contexts and macros). Global variables can also be
#   used for hiding passwords from Asterisk logs, for example for `register`
#   lines or calls to `Dial()` where information about the provider is combined
#   with username and password: when using a global variable, the variable name
#   will be shown in logs, not the actual password. Variables are set in the
#   file as `key = value`. If you pass in a Sensitive type as the value, it
#   will be unwrapped for outputting in the configuration file: this can avoid
#   showing certain sensitive information (as passwords) in puppet logs.
# @param agents_global
#   Global configurations for agents. Options are set in the file as `key =
#   value` in the `[agents]` section of the `agents.conf` file.
# @param features_general
#   Global call features. Options are set in the file as `key = value` in the
#   `[general]` section of `features.conf`.
# @param features_featuremap
#   Global feature maps. Options are set in the file as `key => value` in the
#   `[featuremap]` section of `features.conf`.
# @param features_applicationmap
#   Global application feature maps. Options are set in the file as `key =>
#   value` in the `[applicationmap]` section of `features.conf`.
# @param logger_general
#   Global configurations for asterisk logging. Options are set in the file as
#   `key=value` in the `[general]` section of `logger.conf`.
# @param log_files
#   A hash defining log files. Keys set log filenames and values should be
#   hashes containing at least one key `levels` that has an associated list of
#   strings for levels that'll be output in that log file and an optional key
#   `formatter` which has a string value of either `default` or `json` and
#   defines which format will be output to the log. If the `formatter` key is
#   omitted, the default format is used. Log files can be the special names
#   `console` or `syslog` to determine what output is sent to the asterisk CLI
#   console and syslog, respectively, or it can be a file name. File names can
#   be either relative to the `asterisk.conf` setting `astlogdir` or an
#   absolute path.
# @param queues_general
#   Global configurations for queues. Options are set in the file as `key =
#   value` in the `[general]` section of the `queues.conf` file.
# @param modules_autoload
#   Set this to false to avoid having asterisk load modules automatically on an
#   as-needed basis. This can be used to configure modules in a more
#   restrictive manner.
# @param modules_noload
#   List of modules that asterisk should not load. This can be useful if
#   `modules_autoload` is set to `true`.
# @param modules_load
#   List of modules that asterisk should load on startup. This is useful if
#   you've set `modules_autoload` to `false`.
# @param modules_global
#   Global configurations for modules. Options are set in the file as `key =
#   value` in the `[global]` section of the `modules.conf` file.
# @param manager_enable
#   Set this to false to disable asterisk manager.
# @param manager_port
#   Port number on which asterisk will listen to for manager connections.
#   Defaults to 5038.
# @param manager_bindaddr
#   IP address to have asterisk bind to for manager connections. Defaults to
#   binding to localhost.
#
class asterisk (
  Boolean                        $manage_service,
  Boolean                        $manage_package,
  Variant[String, Array[String]] $package_name,
  String                         $service_name,
  Stdlib::Absolutepath           $confdir,
  Hash                           $iax_general,
  Hash                           $sip_general,
  Hash                           $voicemail_general,
  Hash                           $extensions_general,
  Asterisk::ExtGlobalVars        $extensions_globals,
  Hash                           $agents_global,
  Asterisk::FeaturesGeneral      $features_general,
  Asterisk::Featuremap           $features_featuremap,
  Hash[String,String]            $features_applicationmap,
  Hash[String,String]            $logger_general,
  Hash[String,Asterisk::Logfile] $log_files,
  Hash                           $queues_general,
  Boolean                        $modules_autoload,
  Array[String]                  $modules_noload,
  Array[String]                  $modules_load,
  Hash                           $modules_global,
  Boolean                        $manager_enable,
  Integer                        $manager_port,
  String                         $manager_bindaddr,
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

  Class['asterisk::install']
  -> Class['asterisk::config']
  ~> Class['asterisk::service']

}
