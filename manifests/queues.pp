# This class describes requirements for the asterisk queues to work
class asterisk::queues {
    asterisk::config_dotd {'/etc/asterisk/queues.conf':}
}

