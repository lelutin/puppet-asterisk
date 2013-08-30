# This Class descripes requirments for the asterisk dahdi module to work
class asterisk::sip {
    asterisk::config_dotd {'/etc/asterisk/sip.conf':
      additional_paths => ['/etc/asterisk/sip.registry.d'],
    }
}

