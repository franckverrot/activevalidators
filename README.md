ActiveValidators [![Travis](http://travis-ci.org/cesario/activevalidators.png)](http://travis-ci.org/cesario/activevalidators)
================

Collection of ActiveModel/ActiveRecord validations

Installation (Rails 3)
----------------------

In your Gemfile ( >>= 1.1.0 ):

    gem 'activevalidators'

In your models, the gem provides new validators like `email`, or `url`:

    class User
      validates :email_address, :email => true
      validates :link_url,      :url   => true
      validates :user_phone,    :phone => true
      validates :password,      :password => { :strength => :medium }
      validates :twitter_at,    :twitter => { :format => :username_with_at }
      validates :twitter_url,   :twitter => { :format => :url }
      validates :twitter,       :twitter => true
      validates :postal_code,   :postal_code => { :format => :us }
    end

    class Article
      validates :slug,          :slug => true
      validates :expiration_date,
                      :date => {
                                 :after => lambda { Time.now },
                                 :before => lambda { Time.now + 1.year }
                               }
    end

    class Device
      validates :ipv6,          :ip => { :format => :v6 }
      validates :ipv4,          :ip => { :format => :v4 }
    end

    class Account
      validates :visa_card,     :credit_card => { :type => :visa }
      validates :credit_card,   :credit_card => { :type => :any  }
    end

    class Order
      validates :tracking_num,  :tracking_number => { :carrier => :ups }
    end


Exhaustive list of supported validators and their implementation:

* `email` : based on the `mail` gem
* `url`   : based on a regular expression
* `phone` : based on a set of predefined masks
* `twitter` : based on a regular expression
* `slug`  : based on `ActiveSupport::String#parameterize`
* `ip`    : based on `Resolv::IPv[4|6]::Regex`
* `credit_card` : based on the `Luhn` algorithm
* `date`  : based on the `DateValidator` gem
* `password` : based on a set of regular expressions
* `postal_code`: based on a set of predefined masks
* `tracking_number`: based on a set of predefined masks

Todo
----

Lots of improvements can be made:

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


Contributors
------------
* Franck Verrot
* Oriol Gual
* Paco Guzmán
* Garrett Bjerkhoel
* Renato Riccieri Santos Zannon
* Brian Moseley

Copyright
---------

Copyright (c) 2010-2011 Franck Verrot. MIT LICENSE. See LICENSE for details.
