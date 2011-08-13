# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "munger/version"

Gem::Specification.new do |s|
  s.name        = "munger"
  s.version     = Munger::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bryan Stearns"]
  s.email       = ["bryanstearns@gmail.com"]
  s.homepage    = "http://github.com/bryanstearns/munger"
  s.summary     = %q{File-content munging library (& command-line utility)}
  s.description = """
Programmatically modify files: insert something before, after, or replacing
a line that matches a pattern, or just at the end.
"""

  s.rubyforge_project = "munger"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency(%q<ruby-debug>, [">= 0"])
end
