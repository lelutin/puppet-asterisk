# This Class descripes requirments for the asterisk dahdi module to work
class asterisk::sip (
$sip_options = $asterisk::params::sip_options,
) inherits asterisk::params{
    asterisk::config_dotd {'/etc/asterisk/sip.conf':
      additional_paths => ['/etc/asterisk/sip.registry.d'],
      content          => template('asterisk/sip.conf.erb'),
    }
}

