# @summary Configure a global application map feature
#
# @see http://asteriskdocs.org/en/3rd_Edition/asterisk-book-html-chunk/AdditionalConfig_id256654.html#AdditionalConfig_id243954
#
# @todo Add parameters so that users can declare more than one line in a file.
#
# @param feature
#   Name of the feature.
# @param value
#   Value given to the feature.
# @param ensure
#   Set to `absent` to remove the corresponding file.
#
define asterisk::feature::applicationmap (
  String[1] $feature,
  String[1] $value,
  $ensure = present
) {

  asterisk::dotd::file { "feature__applicationmap_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'features.applicationmap.d',
    content  => "${feature} => ${value}",
    filename => "${name}.conf",
  }

}
