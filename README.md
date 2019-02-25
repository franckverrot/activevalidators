# ActiveValidators [![CircleCI](https://circleci.com/gh/franckverrot/activevalidators.svg?style=svg)](https://circleci.com/gh/franckverrot/activevalidators)

# Description

ActiveValidators is a collection of off-the-shelf and tested ActiveModel/ActiveRecord validations.

## Verify authenticity of this gem

ActiveValidators is cryptographically signed. Please make sure the gem you install hasn’t been tampered with.

Add my public key (if you haven’t already) as a trusted certificate:

    gem cert --add <(curl -Ls https://raw.githubusercontent.com/franckverrot/activevalidators/master/certs/franckverrot.pem)

    gem install activevalidators -P MediumSecurity

The MediumSecurity trust profile will verify signed gems, but allow the installation of unsigned dependencies.

This is necessary because not all of ActiveValidators’ dependencies are signed, so we cannot use HighSecurity.

## Requirements

 * Rails 5.1+
 * Ruby 2.4+

## Installation

    gem install activevalidators

This projects follows [Semantic Versioning a.k.a SemVer](http://semver.org). If you use Bundler, you can use the stabby specifier `~>` safely.

What it means is that you should specify an ActiveValidators version like this :

```ruby
gem 'activevalidators', '~> 5.0.0' # <-- mind the patch version
```

Once you have `require`'d the gem, you will have to activate the validators you
want to use as ActiveValidators doesn't force you to use them all :

```ruby
# Activate all the validators
ActiveValidators.activate(:all)

# Activate only the email and slug validators
ActiveValidators.activate(:email, :slug)

# Activate only the phone
ActiveValidators.activate(:phone)
```

`ActiveValidators.activate` can be called as many times as one wants. It's only
a syntactic sugar on top a normal Ruby `require`.

In a standard Ruby on Rails application, this line goes either in an initializer
(`config/initializers/active_validators_activation.rb` for example), or directly
within `config/application` right inside your `MyApp::Application` class definition.

## Usage

In your models, the gem provides new validators like `email`, or `url`:

```ruby
class User
  validates :company_siren, :siren       => true
  validates :email_address, :email       => true # == :email => { :strict => false }
  validates :link_url,      :url         => true # Could be combined with `allow_blank: true`
  validates :password,      :password    => { :strength => :medium }
  validates :postal_code,   :postal_code => { :country => :us }
  validates :twitter,       :twitter     => true
  validates :twitter_at,    :twitter     => { :format => :username_with_at }
  validates :twitter_url,   :twitter     => { :format => :url }
  validates :user_phone,    :phone       => true
end

class Identification
  validates :nino, :nino => true
  validates :sin,  :sin  => true
  validates :ssn,  :ssn  => true
end

class Article
  validates :slug,            :slug => true
  validates :expiration_date, :date => {
                                          :after => -> (record) { Time.now },
                                          :before => -> (record) { Time.now + 1.year }
                                        }
end

class Device
  validates :ipv4, :ip => { :format => :v4 }
  validates :ipv6, :ip => { :format => :v6 }
end

class Account
  validates :any_card,        :credit_card => true
  validates :visa_card,       :credit_card => { :type => :visa }
  validates :credit_card,     :credit_card => { :type => :any  }
  validates :supported_card,  :credit_card => { :type => [:visa, :master_card, :amex] }
end

class Order
  validates :tracking_num, :tracking_number => { :carrier => :ups }
end

class Product
  validates :code, :barcode => { :format => :ean13 }
end
```

Exhaustive list of supported validators and their implementation:

* `barcode`   : based on known formats (:ean13 only for now)
* `credit_card` : based on the [`credit_card_validations`](https://github.com/Fivell/credit_card_validations) gem
* `date`  : based on the [`date_validator`](https://github.com/codegram/date_validator) gem
* `email` : based on the [`mail`](https://github.com/mikel/mail) gem
* `hex_color` : based on a regular expression
* `ip`    : based on `Resolv::IPv[4|6]::Regex`
* `nino` : National Insurance number (only for UK). Please note that this validation will not accept temporary (such as 63T12345) or administrative numbers (with prefixes like OO, CR, FY, MW, NC, PP, PY, PZ).
* `password` : based on a set of regular expressions
* `phone` : based on a set of predefined masks
* `postal_code`: based on a set of predefined masks
* `regexp` : uses Ruby's [`Regexp.compile`](http://www.ruby-doc.org/core-2.1.1/Regexp.html#method-c-new) method
* `respond_to` : generic Ruby `respond_to`
* `siren` : [SIREN](http://fr.wikipedia.org/wiki/SIREN) company numbers in France
* `slug`  : based on `ActiveSupport::String#parameterize`
* `sin` : Social Insurance Number (only for Canada). You may also allow permanent resident cards (such cards start with '9'): `:sin => {:country => :canada, :country_options => {allow_permanent_residents: true}}`
* `ssn` : Social Security Number (only for USA).
* `tracking_number`: based on a set of predefined masks
* `twitter` : based on a regular expression
* `url`   : based on a regular expression


### Handling error messages

The validators rely on ActiveModel validations, and will require one to use its i18n-based mechanism. Here is a basic example:

```ruby
# user.rb

class User < ActiveRecord::Base
  validates :email, email: {message: :bad_email}
end
```

```yaml
# en.yml

en:
  activerecord:
    errors:
      models:
        user:
          attributes:
            email:
              bad_email: "your error message"
```

## Todo

Lots of improvements can be made:

* Implement new validators
* ...

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.


## Contributors

* Franck Verrot
* Oriol Gual
* Paco Guzmán
* Garrett Bjerkhoel
* Renato Riccieri Santos Zannon
* Brian Moseley
* Travis Vachon
* Rob Zuber
* Manuel Menezes de Sequeira
* Serj L aka Loremaster
* Pierre-Baptiste Béchu

## Copyright

Copyright (c) 2010-2018 Franck Verrot. MIT LICENSE. See LICENSE for details.
