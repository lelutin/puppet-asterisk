# Install an asterisk server.
#
# Options and their values are very numerous, so they will not be detailed in
# this file. All options of this class are detailed in the module's README
# file.
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
