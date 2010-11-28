ActiveValidators
================

Collection of ActiveModel/ActiveRecord validations

Installation (Rails 3)
----------------------

In your Gemfile:

    gem 'activevalidators', :require => 'active_validators'


In your models, the gem provides new validators like `email`, or `url`:

    class User
      validates :email_address, :email => true
      validates :link_url,      :url   => true
    end

Exhaustive list of supported validators:

* `email` : checks the email based on the `mail` gem
* `url`   : checks the url based on a regular expression


Todo
----

Lots of improvements can be made:

* Add I18n of error messages
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
