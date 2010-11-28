# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)

require 'rubygems'
require 'rubygems/specification'
require 'active_validators'

def gemspec
  @gemspec ||= begin
                 file = File.expand_path('../activevalidators.gemspec', __FILE__)
                 eval(File.read(file), binding, file)
               end
end

begin
  require 'rspec/core/rake_task'

  desc "Run specs"
  RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = %w(-fs --color)
    t.ruby_opts  = %w(-w)
  end

  namespace :spec do
    task :clean do
      rm_rf 'tmp'
      rm_rf 'pkg'
    end

    desc "Run the full spec suite"
    task :full => ["clean", "spec"]
  end

rescue LoadError
  task :spec do
    abort "Run `gem install rspec` to be able to run specs"
  end
end

desc "install the gem locally"
task :install => :package do
  sh %{gem install pkg/#{gemspec.name}-#{gemspec.version}}
end

desc "validate the gemspec"
task :gemspec do
  gemspec.validate
end

desc "Build the gem"
task :gem => [:gemspec, :build] do
  mkdir_p "pkg"
  sh "gem build activevalidators.gemspec"
  mv "#{gemspec.full_name}.gem", "pkg"
end

desc "Install ActiveValidators"
task :install => :gem do
  sh "gem install pkg/#{gemspec.full_name}.gem"
end

task :default => :spec
