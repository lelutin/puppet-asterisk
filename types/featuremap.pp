# @summary Options that can be set for featuremap
#
# Those are the possible values that one could find in the `[featuremap]`
# section of `features.conf`.
#
# @see http://asteriskdocs.org/en/3rd_Edition/asterisk-book-html-chunk/AdditionalConfig_id256654.html#AdditionalConfig_id243783 List of featuremaps and their meangings
#
type Asterisk::Featuremap = Struct[{
  Optional[blindxfer]  => String[1],
  Optional[disconnect] => String[1],
  Optional[automon]    => String[1],
  Optional[atxfer]     => String[1],
  Optional[parkcall]   => String[1],
  Optional[automixmon] => String[1],
}]
