# This class describes requirements for the asterisk voicemail to work
class asterisk::voicemail {
    asterisk::config_dotd {'/etc/asterisk/voicemail.conf':}
}

