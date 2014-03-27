define asterisk::feature::applicationmap (
  $feature,
  $value,
  $ensure = present
) {

  $content = inline_template('<%= @feature %> => <%= @value %>')
  asterisk::dotd::file {"${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'features.applicationmap.d',
    content  => $content,
  }

}
