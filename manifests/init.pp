# type that installes asterisk base packages.
class asterisk {
  require asterisk::params

  anchor { 'begin': }
  class { 'asterisk::install': } ->
  class { 'asterisk::config': } ~>
  class { 'asterisk::service': }
  anchor { 'end': }

}

