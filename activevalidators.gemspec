# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = 'activevalidators'
  s.version     = '3.2.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Franck Verrot', 'Paco Guzmán', 'Oriol Gual', 'Garrett Bjerkhoel', 'Renato Riccieri Santos Zannon', 'Brian Moseley', 'Serj L aka Loremaster']
  s.email       = ['franck@verrot.fr']
  s.homepage    = 'http://github.com/franckverrot/activevalidators'
  s.summary     = %q{Collection of ActiveModel/ActiveRecord validations}
  s.description = %q{ActiveValidators is a collection of ActiveModel/ActiveRecord validations}
  s.license     = 'MIT'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'minitest', '~> 4.2.0' # Rails fixes this...
  s.add_dependency 'rake'          , '>= 0.8.7'
  s.add_dependency 'activemodel'   , '>= 3.0.0'
  s.add_dependency 'phony'         , '>= 1.9.0'
  s.add_dependency 'countries'     , '>= 0.9.3'
  s.add_dependency 'mail'
  s.add_dependency 'date_validator'
  s.add_dependency 'credit_card_validations', '~> 1.4.5'

  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.cert_chain  = ['certs/franckverrot.pem']
  s.signing_key = File.expand_path(ENV['RUBYGEMS_CERT_PATH']) if $0 =~ /gem\z/
end
