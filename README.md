ActiveValidators
================

Collection of ActiveModel/ActiveRecord validations

Installation (Rails 3)
----------------------

In your Gemfile ( >>= 1.1.0 ):

    gem 'activevalidators'

**N.B: if you use version <= 1.0.2, use this instead:**

    gem 'activevalidators', :require => 'active_validators'

In your models, the gem provides new validators like `email`, or `url`:

    class User
      validates :email_address, :email => true
      validates :link_url,      :url   => true
      validates :user_phone,    :phone => true
    end

    class Article
      validates :slug,         :slug => true
    end

    class Device
      validates :ipv6,         :ip => { :format => :v6 }
      validates :ipv4,         :ip => { :format => :v4 }
    end


Exhaustive list of supported validators and their implementation:

* `email` : based on the `mail` gem
* `url`   : based on a regular expression
* `phone` : based on a regular expression
* `slug`  : based on `ActiveSupport::String#parameterize`
* `ip`    : based on `Resolv::IPv[4|6]::Regex`

Todo
----

Lots of improvements can be made:

* Add I18n specific types of error messages for each validator
* Implement new validators
* ...

Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2010 Franck Verrot. MIT LICENSE. See LICENSE for details.
