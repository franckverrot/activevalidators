# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'active_validators/version'

Gem::Specification.new do |s|
  s.name        = "activevalidators"
  s.version     = ActiveValidators::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Franck Verrot", "Paco Guzmán", "Oriol Gual", "Garrett Bjerkhoel", "Renato Riccieri Santos Zannon", "Brian Moseley"]
  s.email       = ["franck@verrot.fr"]
  s.homepage    = "http://github.com/cesario/activevalidators"
  s.summary     = %q{Collection of ActiveModel/ActiveRecord validations}
  s.description = %q{ActiveValidators is a collection of ActiveModel/ActiveRecord validations}

  s.add_development_dependency "bundler"
  s.add_development_dependency "minitest"
  s.add_development_dependency "turn"
  s.add_dependency 'rake'          , '>= 0.8.7'
  s.add_dependency 'activerecord'  , '>= 3.0.0'
  s.add_dependency 'activemodel'   , '>= 3.0.0'
  s.add_dependency 'mail'
  s.add_dependency 'date_validator'

  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths      = ["lib"]
end

