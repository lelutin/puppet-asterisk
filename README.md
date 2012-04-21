puppet module to install and configure Asterisk
===============================================

To install Asterisk on a server, simply use the following:

  include asterisk

To install Asterisk and Zaptel kernel modules (NOTE: This is deprecated, Zaptel
is now DAHDI and we should implement setting up DAHDI instead of Zaptel now):

  include asterisk::zaptel

To include french sounds, you can use the following:

  include asterisk::french

Types
-----

  * asterisk::context::extensions

    ```puppet
    asterisk::context::extensions { "incoming":
      ensure => present,
      source => "...",
    }

    asterisk::context::extensions { "incoming":
      ensure  => present,
      content => template(...),
    }

    asterisk::context::extensions { "incoming":
      ensure => absent,
    }
    ```

  * asterisk::context::sip

    ```puppet
    asterisk::context::sip { "1234":
      ensure  => present,
      secret  => 'blah',
      context => 'incoming',
    }

    asterisk::context::sip { "1234":
      ensure => absent,
    }
    ```

    You can also use the 'template_name' argument to either define a template,
    by giving it a value of '!', or inherit from a template:

    ```puppet
    asterisk::context::sip { "corporate_user":
      context => 'corporate',
      type => 'friend',
      # ...
      template_name => '!',
    }
    asterisk::context::sip { "hakim":
      secret => 'ohnoes!',
      template_name => 'corporate_user',
    }
    ```

  * asterisk::registry::sip

    ```puppet
    asterisk::registry::sip { 'providerX':
      server => 'sip.providerX.com',
      user => 'doyoufindme',
    }
    ```

    Password, authuser, port number and extension are optional parameters. If
    you define authuser, you must specify a password.

    ```puppet
    asterisk::registry::sip { 'friends_home':
      server => 'home.friend.com',
      port => '8888',
      user => 'me',
      password => 'myselfandI',
      authuser => 'you',
      extension => 'whatsupfriend',
    }
    ```

  * asterisk::context::iax

    This class works similarly to the asterisk::context::extensions class.

    ```puppet
    asterisk::context::iax { '5551234567':
      source => 'puppet:///modules/site-asterisk/5551234567',
    }
    ```

  * asterisk::registry::iax

    ```puppet
    asterisk::registry::iax { 'providerX':
      server => 'iax.providerX.com',
      user => 'doyoufindme',
      pass => 'attractive?',
    }
    ```

  * asterisk::context::voicemail

    ```puppet
    asterisk::context::voicemail { "3000":
      context => 'some_context',
      password => '5555',
      user_name => 'Bob Bobby',
      email => 'bob@bobby.comcom',
    }
    ```

    You can also use the optional 'pager_email' to set the email that should
    receive a page about new voice messages.

    And finally, the argument 'options' can take a hash of voicemail options
    like the following:

    ```puppet
    asterisk::context::voicemail { "3001":
      context => 'blah',
      password => '112233',
      options => { 'attach' => 'yes', 'delete' => 'yes' },
    }
    ```

Still not implemented !
-----------------------

Types:

  * `asterisk::context::manager`
  * `asterisk::queue`

