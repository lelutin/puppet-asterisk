define asterisk::feature (
  $options,
  $ensure = present
) {

  validate_hash($options)

  asterisk::dotd::file {"${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'features.d',
    content  => template('asterisk/snippet/feature.erb'),
  }

}
