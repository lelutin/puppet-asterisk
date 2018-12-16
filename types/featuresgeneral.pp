# @summary Possible values for the `[general]` section of features.conf
#
# @see http://asteriskdocs.org/en/3rd_Edition/asterisk-book-html-chunk/AdditionalConfig_id256654.html#AdditionalConfig_id244340 List of options and their meaning
#
type Asterisk::Featuresgeneral = Struct[{
  Optional[parkext]               => String[1],
  Optional[parkpos]               => String[1],
  Optional[context]               => String[1],
  Optional[parkinghints]          => Enum['yes','no'],
  Optional[parkingtime]           => Integer,
  Optional[comebacktoorigin]      => Enum['yes','no'],
  Optional[courtesytone]          => String[1],
  Optional[parkedplay]            => Enum['callee','caller','both','no'],
  Optional[parkedcalltransfers]   => Enum['callee','caller','both','no'],
  Optional[parkedcallreparking]   => Enum['callee','caller','both','no'],
  Optional[parkedcallhangup]      => Enum['callee','caller','both','no'],
  Optional[parkedcallrecording]   => Enum['callee','caller','both','no'],
  Optional[parkeddynamic]         => Enum['yes','no'],
  Optional[adsipark]              => Enum['yes','no'],
  Optional[findslot]              => Enum['first','next'],
  Optional[parkedmusicclass]      => String[1],
  Optional[transferdigittimeout]  => Integer,
  Optional[xfersound]             => String[1],
  Optional[xferfailsound]         => String[1],
  Optional[pickupexten]           => String[1],
  Optional[pickupsound]           => String[1],
  Optional[pickupfailsound]       => String[1],
  Optional[featuredigittimeout]   => Integer,
  Optional[atxfernoanswertimeout] => Integer,
  Optional[atxferdropcall]        => Enum['yes','no'],
  Optional[atxferloopdelay]       => Integer,
  Optional[atxfercallbackretries] => Integer,
}]
