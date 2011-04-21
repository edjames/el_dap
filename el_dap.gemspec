#!/usr/bin/env gem build
# encoding: utf-8

require 'base64'

$:.push File.expand_path("../lib", __FILE__)
require "el_dap/version"

Gem::Specification.new do |s|
  s.name        = "el_dap"
  s.version     = ElDap::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ed James"]
  s.email       = Base64.decode64("ZWQuamFtZXMuZW1haWxAZ21haWwuY29t\n")
  s.homepage    = "https://github.com/edjames/el_dap"
  s.summary     = "Simple search and authentication tool for Active Directory"
  s.description = "#{s.summary}. This included support for both Ruby 1.9 and ruby 1.8 (using the SystemTimer gem)."

  s.rubyforge_project = "el_dap"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency("net-ldap", "~> 0.2.2")
  s.add_development_dependency "bundler"
  
  # If Ruby version is 1.8 then check for SystemTimer gem
  if RUBY_VERSION < "1.9"
    begin
      require 'system_timer'
    rescue LoadError => ex
      warn "WARNING: To use ElDap in Ruby 1.8 you must have the SystemTimer gem installed. Please run: gem install SystemTimer"
      raise ex.message
    end
  end
end
