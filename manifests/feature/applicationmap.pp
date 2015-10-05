# Configure a feature in the special context [applicationmap]
#
# $feature is the name of the feature.
#
# $value is the value given to the feature.
#
# $ensure can be set to absent to remove the corresponding file.
#
define asterisk::feature::applicationmap (
  $feature,
  $value,
  $ensure = present
) {

  $content = inline_template('<%= @feature %> => <%= @value %>')
  asterisk::dotd::file {"feature__applicationmap_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'features.applicationmap.d',
    content  => $content,
    filename => "${name}.conf",
  }

}
