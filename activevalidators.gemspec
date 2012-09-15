# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = 'activevalidators'
  s.version     = '2.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Franck Verrot', 'Paco Guzmán', 'Oriol Gual', 'Garrett Bjerkhoel', 'Renato Riccieri Santos Zannon', 'Brian Moseley']
  s.email       = ['franck@verrot.fr']
  s.homepage    = 'http://github.com/franckverrot/activevalidators'
  s.summary     = %q{Collection of ActiveModel/ActiveRecord validations}
  s.description = %q{ActiveValidators is a collection of ActiveModel/ActiveRecord validations}

  s.required_ruby_version = '>= 1.9.2'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'minitest'
  s.add_dependency 'rake'          , '>= 0.8.7'
  s.add_dependency 'activemodel'   , '>= 3.0.0'
  s.add_dependency 'phony'         , '~> 1.7.4'
  s.add_dependency 'countries'     , '~> 0.8.2'
  s.add_dependency 'mail'
  s.add_dependency 'date_validator'

  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
end
