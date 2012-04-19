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

  * asterisk::extensions::context

    ```puppet
    asterisk::extensions::context { "incoming":
      ensure => present,
      source => "...",
    }

    asterisk::extensions::context { "incoming":
      ensure  => present,
      content => template(...),
    }

    asterisk::extensions::context { "incoming":
      ensure => absent,
    }
    ```

  * asterisk::account::sip

    ```puppet
    asterisk::account::sip { "1234":
      ensure  => present,
      secret  => 'blah',
      context => 'incoming',
    }

    asterisk::account::sip { "1234":
      ensure => absent,
    }
    ```

    You can also use the 'template_name' argument to either define a template,
    by giving it a value of '!', or inherit from a template:

    ```puppet
    asterisk::account::sip { "corporate_user":
      context => 'corporate',
      type => 'friend',
      # ...
      template_name => '!',
    }
    asterisk::account::sip { "hakim":
      secret => 'ohnoes!',
      template_name => 'corporate_user',
    }
    ```

  * asterisk::account::voicemail

    ```puppet
    asterisk::account::voicemail { "3000":
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
    asterisk::account::voicemail { "3001":
      context => 'blah',
      password => '112233',
      options => { 'attach' => 'yes', 'delete' => 'yes' },
    }
    ```

Still not implemented !
-----------------------

Types:

  * `asterisk::account::iax`
  * `asterisk::account::manager`
  * `asterisk::queue`

