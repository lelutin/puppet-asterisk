# This Class descripes requirments for the asterisk dahdi module to work
class asterisk::unimrcp {

    package { 'astunimrcp':
            ensure => 'latest',
            }

}
