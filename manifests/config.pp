# @summary asterisk basic configuration files.
#
# This class is not intended to be used directly.
#
# @api private
#
class asterisk::config {
  assert_private()

  file { $asterisk::confdir:
    ensure => directory,
    owner  => 'asterisk',
    group  => 'asterisk',
    mode   => '0755',
  }

  if $asterisk::purge_confdir {
    File[$asterisk::confdir] {
      purge   => true,
      recurse => true,
    }
  }

  $cf_with_directory = [
    'iax',
    'sip',
    'voicemail',
    'extensions',
    'agents',
    'features',
    'queues',
    'manager',
  ]
  $directories = $cf_with_directory + ['iax.registry', 'sip.registry']

  $directories.each |String $dir| {
    file { "${asterisk::confdir}/${dir}.d":
      ensure => directory,
      owner  => 'asterisk',
      group  => 'asterisk',
      mode   => '0750',
    }

    # lint:ignore:140chars
    # Avoid error messages
    # [Nov 19 16:09:48] ERROR[3364] config.c: *********************************************************
    # [Nov 19 16:09:48] ERROR[3364] config.c: *********** YOU SHOULD REALLY READ THIS ERROR ***********
    # [Nov 19 16:09:48] ERROR[3364] config.c: Future versions of Asterisk will treat a #include of a file that does not exist as an error, and will fail to load that configuration file.  Please ensure that the file '/etc/asterisk/iax.conf.d/*.conf' exists, even if it is empty.
    # lint:endignore
    file { "${asterisk::confdir}/${dir}.d/null.conf":
      ensure  => file,
      owner   => 'asterisk',
      group   => 'asterisk',
      mode    => '0640',
      content => '',
    }
  }

  # Options for the logfiles configuration file need some special per-line
  # formatting. This creates one formatted string value for each config line
  # and returns a hash with the string values instead of the sub-hash.
  $formatted_logfiles = $asterisk::log_files.map |$section, $options| {
    if $options['formatter'] !~ Undef {
      $formatter = "[${options['formatter']}]"
    }
    else {
      $formatter = ''
    }

    $return_value = {
      $section => "${formatter}${options['levels'].join(',')}",
    }
  }.reduce({}) |$result, $value| { $result + $value }

  $configs_with_registry = ['iax', 'sip']
  $config_sections = {
    iax => {
      general => {
        delimiter => '=',
        options   => $asterisk::iax_general,
      },
    },
    sip => {
      general => {
        delimiter => '=',
        options   => $asterisk::sip_general,
      },
    },
    voicemail => {
      general => {
        delimiter => '=',
        options   => $asterisk::voicemail_general,
      },
    },
    extensions => {
      general => {
        delimiter => '=',
        options   => $asterisk::extensions_general,
      },
      globals => {
        delimiter => '=',
        options   => $asterisk::extensions_globals,
      },
    },
    agents => {
      general => {
        delimiter => '=',
        options   => {},
      },
      agents => {
        delimiter => '=',
        options   => $asterisk::agents_global,
      },
    },
    features => {
      general => {
        delimiter => '=',
        options   => $asterisk::features_general,
      },
      featuremap => {
        delimiter => ' => ',
        options   => $asterisk::features_featuremap,
      },
      applicationmap => {
        delimiter => ' => ',
        options   => $asterisk::features_applicationmap,
      },
    },
    queues => {
      general => {
        delimiter => '=',
        options   => $asterisk::queues_general,
      },
    },
    logger => {
      general => {
        delimiter => '=',
        options   => $asterisk::logger_general,
      },
      logfiles => {
        delimiter => ' => ',
        options   => $formatted_logfiles,
      },
    },
    manager => {
      general => {
        delimiter => '=',
        options   => {
          enabled  => $asterisk::manager_enable,
          port     => $asterisk::manager_port,
          bindaddr => $asterisk::manager_bindaddr,
        },
      },
    },
    modules => {
      modules => {
        delimiter         => ' => ',
        # Asterisk's config format is really weird. It looks like ini file but
        # it's not exactly that, and it can sometimes (like in this case) mix
        # up two types of option delimiters in the same section. The value in
        # oddball_options use '=' instead of ' => '
        oddball_delimiter => '=',
        oddball_options   => {
          autoload => bool2str($asterisk::modules_autoload, 'yes', 'no'),
        },
        options           => {
          preload => $asterisk::modules_preload,
          load    => $asterisk::modules_load,
          noload  => $asterisk::modules_noload,
        },
      },
      global => {
        delimiter => '=',
        options   => $asterisk::modules_global,
      },
    },
  }

  $config_files = $cf_with_directory + [
    'logger',
    'modules',
  ]
  $config_files.each |String $filename| {
    if $filename in $cf_with_directory {
      $main_cf_dir = ["${filename}.d"]
    }
    else {
      $main_cf_dir = []
    }

    if $filename in $configs_with_registry {
      $cf_directories = $main_cf_dir + ["${filename}.registry.d"]
    } else {
      $cf_directories = $main_cf_dir
    }

    $template_variables = {
      config_name  => $filename,
      include_dirs => $cf_directories,
      sections     => $config_sections[$filename],
    }
    file { "${asterisk::confdir}/${filename}.conf":
      ensure  => file,
      owner   => 'asterisk',
      group   => 'asterisk',
      mode    => '0640',
      content => epp('asterisk/config_file.conf.epp', $template_variables),
    }
  }
}
