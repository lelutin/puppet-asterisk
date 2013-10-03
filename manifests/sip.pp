# This Class descripes requirments for the asterisk sip system to work
class asterisk::sip (
$sip_options = $asterisk::params::sip_options,
) inherits asterisk::params{

  validate_array($sip_options['allow'])
  validate_array($sip_options['disallow'])
  validate_array($sip_options['domain'])
  validate_array($sip_options['localnet'])
  
  asterisk::config_dotd {'/etc/asterisk/sip.conf':
      additional_paths => ['/etc/asterisk/sip.registry.d'],
      content          => template('asterisk/sip.conf.erb'),
    }
}

