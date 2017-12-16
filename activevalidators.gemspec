# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = 'activevalidators'
  s.version     = '4.0.3'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Franck Verrot', 'Paco Guzmán', 'Oriol Gual', 'Garrett Bjerkhoel', 'Renato Riccieri Santos Zannon', 'Brian Moseley', 'Serj L aka Loremaster']
  s.email       = ['franck@verrot.fr']
  s.homepage    = 'http://github.com/franckverrot/activevalidators'
  s.summary     = %q{Collection of ActiveModel/ActiveRecord validations}
  s.description = %q{ActiveValidators is a collection of ActiveModel/ActiveRecord validations}
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.2.2'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'minitest'
  s.add_dependency 'rake'
  s.add_dependency 'mail'
  s.add_dependency 'date_validator'
  s.add_dependency 'activemodel'            , '>= 3.0'
  s.add_dependency 'phony'                  , '~> 2.0'
  s.add_dependency 'countries'              , '>= 1.2'
  s.add_dependency 'credit_card_validations', '~> 3.2'

  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.cert_chain  = ['certs/franckverrot.pem']
  s.signing_key = File.expand_path(ENV['RUBYGEMS_CERT_PATH']) if $0 =~ /gem\z/
end
