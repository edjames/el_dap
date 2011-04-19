# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "el_dap/version"

Gem::Specification.new do |s|
  s.name        = "el_dap"
  s.version     = ElDap::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ed James"]
  s.email       = ["ed.james.email@gmail.com"]
  s.homepage    = "https://github.com/edjames/el_dap"
  s.summary     = %q{A simple search and authentication tool for Active Directory using LDAP.}
  s.description = %q{A simple search and authentication tool for Active Directory using LDAP.}

  s.rubyforge_project = "el_dap"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency("net-ldap", "~> 0.2.2")
end
