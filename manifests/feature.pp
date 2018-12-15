# Configure an asterisk feature
#
# $options is a hash of options with keys being option names and values their
#   values.
#
# $ensure can be set to absent to remove certain feature
#
define asterisk::feature (
  Hash $options,
  $ensure = present
) {

  asterisk::dotd::file { "feature_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'features.d',
    content  => template('asterisk/snippet/feature.erb'),
    filename => "${name}.conf",
  }

}
