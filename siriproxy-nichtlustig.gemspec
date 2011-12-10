# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-nichtlustig"
  s.version     = "0.0.1" 
  s.authors     = ["mu"]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = %q{An Example Siri Proxy Plugin}
  s.description = %q{extended plamonis siriproxy example plugin with some custom responses for Austrian/German. }

  s.rubyforge_project = "siriproxy-nichtlustig"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "eat"
  s.add_runtime_dependency "httparty"
  #s.add_runtime_dependency "timeout"
end