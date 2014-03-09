# This class describes requirements for the asterisk iax configurations to work
class asterisk::iax (
$iax_options = $asterisk::params::iax_options,
) inherits asterisk::params {
    asterisk::config_dotd {'/etc/asterisk/iax.conf':
      additional_paths => ['/etc/asterisk/iax.registry.d'],
      content          => template('asterisk/iax.conf.erb'),
    }
}

