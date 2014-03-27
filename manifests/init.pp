# type that installes asterisk base packages.
class asterisk (
  $manage_service          = $asterisk::params::manage_service,
  $package_name            = $asterisk::params::package_name,
  $service_name            = $asterisk::params::service_name,
  $confdir                 = $asterisk::params::confdir,
  $iax_options             = {},
  $sip_options             = {},
  $voicemail_options       = {},
  $extensions_options      = {},
  $agents_multiplelogin    = $asterisk::params::agents_multiplelogin,
  $agents_options          = {},
  $features_options        = $asterisk::params::features_options,
  $features_featuremap     = {},
  $queues_options          = {},
  $modules_autoload        = $asterisk::params::modules_autoload,
  $modules_noload          = $asterisk::params::modules_noload,
  $modules_load            = $asterisk::params::modules_load,
  $modules_global_options  = {},
  $manager_enable          = $asterisk::params::manager_enable,
  $manager_port            = $asterisk::params::manager_port,
  $manager_bindaddr        = $asterisk::params::manager_bindaddr
) inherits asterisk::params {

  validate_bool($manage_service)
  validate_absolute_path($confdir)
  validate_hash($iax_options)
  validate_hash($sip_options)
  validate_hash($voicemail_options)
  validate_hash($extensions_options)
  validate_bool($agents_multiplelogin)
  validate_hash($agents_options)
  validate_hash($features_options)
  validate_hash($features_featuremap)
  validate_hash($queues_options)
  validate_bool($modules_autoload)
  validate_array($modules_noload)
  validate_array($modules_load)
  validate_hash($modules_global_options)
  validate_bool($manager_enable)
  if !is_integer($manager_port) {
    fail('Parameter $manager_port needs to be an integer value')
  }
  validate_string($manager_bindaddr)
  validate_string($package_name)
  validate_string($service_name)

  $real_iax_options = merge($asterisk::params::iax_options, $iax_options)
  validate_array($real_iax_options['allow'])
  validate_array($real_iax_options['disallow'])
  $real_sip_options = merge($asterisk::params::sip_options, $sip_options)
  validate_array($real_sip_options['allow'])
  validate_array($real_sip_options['disallow'])
  validate_array($real_sip_options['domain'])
  validate_array($real_sip_options['localnet'])
  $real_voicemail_options = merge(
    $asterisk::params::voicemail_options, $voicemail_options
  )
  $real_extensions_options = merge(
    $asterisk::params::extensions_options,
    $extensions_options
  )
  $real_agents_multiplelogin = $agents_multiplelogin ? {
    true  => 'yes',
    false => 'no',
  }
  $real_features_options = merge(
    $asterisk::params::features_options,
    $features_options
  )
  $real_queues_options = merge(
    $asterisk::params::queues_options,
    $queues_options
  )
  $real_modules_autoload = $modules_autoload ? {
    true  => 'yes',
    false => 'no',
  }
  $real_manager_enable = $manager_enable ? {
    true  => 'yes',
    false => 'no',
  }

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up. You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'begin': } ->
  class { 'asterisk::install': } ->
  class { 'asterisk::config': } ~>
  class { 'asterisk::service': } ->
  anchor { 'end': }

}

