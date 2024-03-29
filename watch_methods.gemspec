# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "watch_methods/version"

Gem::Specification.new do |s|
  s.name        = "watch_methods"
  s.version     = WatchMethods::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mike Lewis"]
  s.email       = ["ft.mikelewis@gmail.com"]
  s.homepage    = "http://github.com/mikelewis/watch_methods"
  s.summary     = %q{Easily monitor methods added within classes and modules.}
  s.description = %q{Easily monitor methods added within classes and modules.}

  s.rubyforge_project = "method_added_hook"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
