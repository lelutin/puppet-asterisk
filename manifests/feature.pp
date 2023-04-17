# @summary Configure an asterisk feature application map grouping
#
# This resource will define an application map grouping. It can be used to set
# dynamic features with the DYNAMIC_FEATURES variable: instead of listing all
# of the application maps that need to be enabled in DYNAMIC_FEATURES, you can
# use the name of a group to enable them all.
#
# To configure global features, see the `features_general` parameter to the
# main class, `asterisk`.
#
# @example feature configuration
#   asterisk::feature { 'shifteight':
#     options => {
#       unpauseMonitor => '*1',
#       pauseMonitor   => '*2',
#     }
#   }
#
# @see http://asteriskdocs.org/en/3rd_Edition/asterisk-book-html-chunk/AdditionalConfig_id256654.html#AdditionalConfig_id256980
# @see https://www.voip-info.org/asterisk-config-featuresconf/
#
# @todo list specific options as params instead of using an options hash
#
# @param options
#   Hash of options with keys being option names and values their values.
# @param ensure
#   Set this to `absent` to remove the feature.
#
define asterisk::feature (
  Hash                       $options,
  Stdlib::Ensure::File::File $ensure = file,
) {
  $feature_variables = {
    context => $name,
    options => $options,
  }
  asterisk::dotd::file { "featuremap_group_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'features.d',
    content  => epp('asterisk/snippet/feature.epp', $feature_variables),
    filename => "${name}.conf",
  }
}
