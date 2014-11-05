# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "onepageapi"
  s.version     = "0.0.1"
  s.authors     = ["OnePageCRM"]
  s.homepage    = ""
  s.summary     = "This is a short ruby script to help you get started with the OnePageCRM API v3"
  s.description = ""
  s.license     = "MIT"

  s.rubyforge_project = "onepageapi"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
