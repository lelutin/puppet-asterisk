# This Class descripes requirments for the asterisk dahdi module to work
class asterisk::voicemail {
    asterisk::config_dotd {'/etc/asterisk/voicemail.conf':}
}

