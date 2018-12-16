# @summary Install and configure an asterisk server.
#
# @example simple install
#   class { 'asterisk': }
#
# @see http://www.asteriskdocs.org/en/3rd_Edition/asterisk-book-html-chunk/ACD_id288901.html#options_general_queues_id001 General queues options
#
# @todo Purge unmanaged configs by default. Add parameter to disable purging.
# @todo Add hash-based params that can be used to create a set of resources for each type with create_resource. This can be useful for pushing data out to hiera.
# @todo make it possible to manage dialplan with the two other methods (e.g. AEL and Lua)
# @todo manage options for the `[globals]` section of extensions.conf
# @todo overhaul README file before release. lots of things have changed
#
# @param manage_service
#   Set this to false to avoid managing the asterisk service. By default puppet
#   will enable the service and ensure that it is running.
# @param manage_package
#   Set this to false to avoid installing the asterisk package.
# @param package_name
#   Name of the package being installed for asterisk.
# @param service_name
#   Name of the asterisk service.
# @param confdir
#   Absolute path to the asterisk configuration directory.
#
# @param iax_options
#   Options for the global section of the iax.conf file. Options are set in the
#   file as `key = value`.
# @param sip_options
#   Options for the global section of the sip.conf file. Options are set in the
#   file as `key = value`.
# @param voicemail_options
#   Options for the global section of the voicemail.conf file. Options are set
#   in the file as `key = value`.
# @param extensions_options
#   Options for the global section of the extensions.conf file. Options are set
#   in the file as `key = value`.
# @param agents_multiplelogin
#   Set this to false to disable possibility for agents to be logged in
#   multiple times. This option is set in the `general` section of the
#   agents.conf file.
# @param agents_options
#   Options for the global `agents` section of the agents.conf file. Options
#   are set in the file as `key = value`.
# @param features_options
#   Global call features. Options are set in the file as `key = value`.
# @param features_featuremap
#   Global feature maps. Options are set in the file as `key => value`.
# @param features_applicationmap
#   Global application feature maps. Options are set in the file as `key =>
#   value`.
# @param queues_options
#   Options for the global section of the queues.conf file. Options are set in
#   the file as `key = value`.
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
# @param modules_global_options
#   Options for the global section of the modules.conf file. Options are set in
#   the file as `key = value`.
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
  Boolean              $manage_service          = true,
  Boolean              $manage_package          = true,
  String               $package_name            = 'asterisk',
  String               $service_name            = 'asterisk',
  Stdlib::Absolutepath $confdir                 = '/etc/asterisk',
  Hash                 $iax_options             = {},
  Hash                 $sip_options             = {},
  Hash                 $voicemail_options       = {},
  Hash                 $extensions_options      = {},
  Boolean              $agents_multiplelogin    = true,
  Hash                 $agents_options          = {},
  Hash                 $features_options        = $asterisk::params::features_options,
  Hash                 $features_featuremap     = {},
  Hash                 $features_applicationmap = {},
  Hash                 $queues_options          = {},
  Boolean              $modules_autoload        = true,
  Array[String]        $modules_noload          = $asterisk::params::modules_noload,
  Array[String]        $modules_load            = $asterisk::params::modules_load,
  Hash                 $modules_global_options  = {},
  Boolean              $manager_enable          = true,
  Integer              $manager_port            = 5038,
  String               $manager_bindaddr        = '127.0.0.1',
) inherits asterisk::params {

  # We'll only ensure the type of some of the *_options on which templates iterate

  $real_iax_options = merge($asterisk::params::iax_options, $iax_options)
  assert_type(Array[String], $real_iax_options['allow'])
  assert_type(Array[String], $real_iax_options['disallow'])
  $real_sip_options = merge($asterisk::params::sip_options, $sip_options)
  assert_type(Array[String], $real_sip_options['allow'])
  assert_type(Array[String], $real_sip_options['disallow'])
  assert_type(Array[String], $real_sip_options['domain'])
  assert_type(Array[String], $real_sip_options['localnet'])
  $real_voicemail_options = merge(
    $asterisk::params::voicemail_options, $voicemail_options
  )
  $real_extensions_options = merge(
    $asterisk::params::extensions_options,
    $extensions_options
  )
  $real_agents_multiplelogin = bool2str($agents_multiplelogin, 'yes', 'no')
  $real_features_options = merge(
    $asterisk::params::features_options,
    $features_options
  )
  $real_queues_options = merge(
    $asterisk::params::queues_options,
    $queues_options
  )
  $real_modules_autoload = bool2str($modules_autoload, 'yes', 'no')
  $real_manager_enable = bool2str($manager_enable, 'yes', 'no')

  contain asterisk::install
  contain asterisk::config
  contain asterisk::service

  Class['asterisk::install']
  -> Class['asterisk::config']
  ~> Class['asterisk::service']

}
