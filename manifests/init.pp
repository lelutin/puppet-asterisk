# type that installes asterisk base packages.
class asterisk (
  $manage_service = $asterisk::params::manage_service,
  $confdir        = $asterisk::params::confdir,
  $iax_options    = {},
  $sip_options    = {},
  $package_name   = $asterisk::params::package_name,
  $service_name   = $asterisk::params::service_name
) inherits asterisk::params {

  validate_bool($manage_service)
  validate_absolute_path($confdir)
  validate_hash($iax_options)
  validate_hash($sip_options)
  validate_string($package_name)
  validate_string($service_name)

  $real_iax_options = merge($asterisk::params::iax_options, $iax_options)
  $real_sip_options = merge($asterisk::params::sip_options, $sip_options)

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up. You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'begin': } ->
  class { 'asterisk::install': } ->
  class { 'asterisk::config': } ~>
  class { 'asterisk::service': } ->
  anchor { 'end': }

}

