# type that installes asterisk base packages.
class asterisk (
  $manage_service = $asterisk::params::manage_service,
  $confdir        = $asterisk::params::confdir,
  $iax_options    = $asterisk::params::iax_options,
  $sip_options    = $asterisk::params::sip_options,
  $package_name   = $asterisk::params::package_name,
  $service_name   = $asterisk::params::service_name
) inherits asterisk::params {

  anchor { 'begin': }
  class { 'asterisk::install': } ->
  class { 'asterisk::config': } ~>
  class { 'asterisk::service': }
  anchor { 'end': }

}

