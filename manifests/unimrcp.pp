# This class installs UniMRCP
class asterisk::unimrcp {

  # FIXME this class is unusable as-is. See reason below
  # XXX This package doesn't exist in debian repositories, either specify the
  # addition apt source or if it's in another distro, put a barrier with
  # $::lsbdistcodename.
  package { 'astunimrcp':
    ensure => 'latest',
  }

}
