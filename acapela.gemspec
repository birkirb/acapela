# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "acapela/constants"

Gem::Specification.new do |s|
  s.name        = "acapela"
  s.version     = Acapela::VERSION
  s.authors     = ["Birkir A. Barkarson"]
  s.email       = ["birkirb@stoicviking.net"]
  s.homepage    = "https://github.com/birkirb/acapela"
  s.summary     = %q{Generate speech from the Acapela text to voice service.}
  s.description = %q{Ruby interface to Acapela's API for generating speech from text. More info http://www.acapela-vaas.com/}

  s.rubyforge_project = "acapela"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency("backports")
  s.add_development_dependency("rspec", '>= 2.6.0')
  s.add_development_dependency("mocha", '>= 0.9.0')
end
