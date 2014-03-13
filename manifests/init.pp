# type that installes asterisk base packages.
class asterisk (
  $manage_service         = $asterisk::params::manage_service,
  $confdir                = $asterisk::params::confdir,
  $iax_options            = {},
  $sip_options            = {},
  $voicemail_options      = {},
  $extensions_options     = {},
  $modules_autoload       = $asterisk::params::modules_autoload,
  $modules_noload         = $asterisk::params::modules_noload,
  $modules_load           = $asterisk::params::modules_load,
  $modules_global_options = $asterisk::params::modules_global_options,
  $package_name           = $asterisk::params::package_name,
  $service_name           = $asterisk::params::service_name
) inherits asterisk::params {

  validate_bool($manage_service)
  validate_absolute_path($confdir)
  validate_hash($iax_options)
  validate_hash($sip_options)
  validate_hash($voicemail_options)
  validate_hash($extensions_options)
  validate_bool($modules_autoload)
  validate_array($modules_noload)
  validate_array($modules_load)
  validate_hash($modules_global_options)
  validate_string($package_name)
  validate_string($service_name)

  $real_iax_options = merge($asterisk::params::iax_options, $iax_options)
  $real_sip_options = merge($asterisk::params::sip_options, $sip_options)
  $real_voicemail_options = merge(
    $asterisk::params::voicemail_options, $voicemail_options
  )
  $real_extensions_options = merge(
    $asterisk::params::extensions_options,
    $extensions_options
  )

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up. You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'begin': } ->
  class { 'asterisk::install': } ->
  class { 'asterisk::config': } ~>
  class { 'asterisk::service': } ->
  anchor { 'end': }

}

