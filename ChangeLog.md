# UNRELEASED

  * Make country case-insensitive for postal codes
  * Loosen up the dependency on countries

# 3.2.0

## MAJOR CHANGES

  * Ensure the $LOAD\_PATH could never break ActiveValidators (see #71 for details)

## DEPRECATION

  * [SSN validations doesn't support any options anymore][ssn_validation_options]

## FEATURES

  * Regexp validator.

# 3.1.0

## FEATURES

  * Remove default requiring
  * Remove deprecation messages about `ActiveValidators.activate`

# 3.0.1 (yanked, it's now 3.1.0)

# 3.0.0

*TL;DR : deprecating default require's and introduced a way to activate them independently.*

## BREAKING CHANGES for the 3.x versions

  * Validators should be manually required using `ActiveValidators.activate`. See README for details on how to use it.

## FEATURES

  * Require all the validators by default until 3.0.1
  * EAN13 barcode validation
  * NINO validation (UK)
  * SIN validation (Canada)
  * SSN (Social Security Number) validation (USA)

# 2.1.0

  * Loosen up the dependency on phony
  * Cleaning up the test helper
  * Some requires were obsolete and loading nothing.
  * .travis.yml : Rework the list of supported Rubies
  * Credit\_card\_validator : Change the luhn algorithm & code cleanup
  * Email\_validator.rb : Extract method in the email validator
  * Update .travis.yml
  * Remove Rubies &lt; 1.9.3
  * Add activesupport requires needed to make tests pass
  * Add tests for IPAddr
  * Cast ip value to string before using string methods
  * Countries (from 0.8.4 to 0.9.2), phony (from 1.7.12 to 1.9.0)
  * Fix: :rubygems is deprecated because HTTP requests are insecure
  * SIREN Validator

# 2.0.2

  * Postal code for the Cayman Islands
  * Add option to email validator to allow quick validation via a lambda function
  * Rework the postal code validator to support 1.8 again.
  * Convert to 1.8 syntax and reindent.

# 2.0.1

  * Replace ^,$ with \A,\z in TrackingNumberValidator
  * Like the fixes before, including all tests.
  * Prevent string injection in postal codes via \A,\z
  * Just corrected the regular expression to use \A and \z instead of ^ and $.
  * Ensure to use \A and \z in twitter regexps
  * Regular expressions for the twitter usernames.
  * Wrap URL regexp with \A and \z
  * Also added a test case to ensure this is not possible.

# 2.0.0

  * Clean a bit the email validations' tests.
  * Fix: phone validator accepts custom message
  * Email validator accept only full address
  * :strict changed to :only\_address due to :strict is registered word
  * Fixed travis for 1.9x
  * Fixes phone validator
  * Tests for international format
  * Phone validation dependency on Phony gem
  * Transform @ as word character
  * Added postal code validators by geonames.info
  * Replace custom url regexp with URI.regexp

# 1.9.0

  * Update the email validation example
  * (Feature) Added strict email notion for email\_validator
  * Uenamed duplicate test cases
  * Umprove the email validator to be more restrictive
  * Update .travis.yml

# 1.8.1

  * Remove active\_record dependency
  * Add Manuel to the list of contributors
  * Improve the README a bit

# 1.8.0

  * TrackingNumberValidator: fix in the USPS computation.
  * Tests: removed turn because it was failing everywhere but on 1.9.x.
  * PostalCodeValidator: Added Portuguese postal-code format.
  * Remove turn.
  * Corrected example of use of the postal code validator.
  * Added a new option country\_method allowing the country to be obtained by calling a method of the record. Also added support for string in option 'contry'.
  * Added Portuguese postal-code format.
  * Properly handle checksums of '0' in usps mod10.
  * Current implementation returns 10, which does not equal 0.
  * Simplify the test and make sure Ruby 1.9x stop complaining

# 1.7.1

  * Fix the usage of date\_validator

# 1.7.0

  * Update the URL regex to support Basic Auth and port numbers
  * check value#blank? in validations
  * Fix the link to Travis
  * Implemented :credit\_card => true
  * Github's caching the build status image, so using https from now on.
  * Let's require all the validations

# 1.6.0

  * Added two new contributors
  * Merged @utahstreetlabs' work on the tracking number validator.
  * Added RBX, RBX 2.0 and JRuby to the build matrix
  * We don't need to require the whole path here
  * Silence some warnings, as we run with Ruby with the -w flag.
  * Add 1.9.3 to the build matrix
  * Dropped RSpec in favor of MiniTest
  * Added Travis' build status logo.
  * Added .travis.yml for testing against multiple Ruby VMs
  * Added rake as a dependency

# 1.5.1

  * Fix UPS tracking number's validation

# 1.5

  * Fix copy-and-paste error with tracking number formats
  * Add ups tracking number validation

# 1.4.0

  * Add Renato and Brian in both README and Gemspec
  * Feature: postal\_code validation is now available.
  * Fixed Ruby 1.8.7 support
  * Remove and ignore Gemfile.lock
  * Add postal code validator
  * Based on the phone validator, the only country it knows about is :us
  * Implemented 'old-school' validator methods dynamically
  * DRYed validator loading
  * Fix 1.9 compatiblity
  * Bump up date\_validator, version number and dependencies in the Gemfile
  * Refactored phone validator
  * ActiveValidators now supports Twitter urls (both URLs and usernames with @
  * Added twitter username validator

# 1.2.3

  * Added :blank error message
  * Add spec for empty slug
  * Fixed NoMethodError when the slug isnt set quite yet, but will still fail validation

# 1.2.2

  * Added a password validator (based on regexes)
  * Added the contributor section in the README
  * The Luhn algorithm has been implemented, so no need for the Luhnacy gem

# 1.2.1

  * Fix bug in Mail Validator when a complete email address was given
  * Add spec for https urls
  * Refactor URL Validator specs
  * Refactor Slug Validator specs
  * Refactor Respond To Validator specs
  * Refactor Phone Validator specs
  * Refactor Email Validator specs
  * Refactor Credit Card specs
  * Use generic TestRecord for IPValidator
  * Add generic TestRecord
  * Add validity check standard to IPValidator and refactor
  * Fix IPv4 validation for all rubies
  * Ignore rbx files

# 1.2.0

  * Added the test file from DateValidator to make sure that the tests passes, or that at least the validations are available thru ActiveValidator
  * Added date\_validator in order to support date validation
  * Drop Luhnacy, very simple implementation, supports lots of cards.
  * Add credit card validation for American Express, Visa, Switch, and MasterCard
  * Added IP validators

# 1.1.0

  * Add errors with the ActiveModel::Errors#add method -> i18n support
  * Add phone format validator
  * Public release


[ssn_validation_options]: https://github.com/franckverrot/activevalidators/commit/dee076a8e344897f0325747504625285be7da226
