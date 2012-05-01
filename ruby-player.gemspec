# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ruby-player/version"

Gem::Specification.new do |s|
  s.name        = "ruby-player"
  s.version     = Player::VERSION
  s.authors     = ["Aleksey Timin"]
  s.email       = ["atimin@gmail.com"]
  s.homepage    = "http://www.github.com/flipback/ruby-player"
  s.summary     = %q{Ruby player - client library for the Player (operation system for robots) in pure Ruby.}
  s.description = %q{Ruby Player - client library for the Player (operation system for robots) in pure Ruby.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.9.2'

  s.add_runtime_dependency "isna", '~>0.0.4'

  s.add_development_dependency "rspec", '~> 2.7'
  s.add_development_dependency "rake", '~> 0.9'
  s.add_development_dependency "pry"
  s.add_development_dependency "yard"
  s.add_development_dependency "redcarpet"
  s.add_development_dependency 'guard-rspec'
end
