# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'goji_labs/version'

Gem::Specification.new do |spec|
  spec.name          = "goji_labs"
  spec.version       = GojiLabs::VERSION
  spec.authors       = ["Adam Sumner"]
  spec.email         = ["adam@gojilabs.com"]

  spec.summary       = %q{Utility functions for us to use at Goji Labs.}
  spec.description   = %q{This gem helps us determine our environments and manage environment variables for all of our projects. As we work on more projects, this gem will grow and interesting parts will be broken out for all to use.}
  spec.homepage      = "http://gojilabs.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "activesupport", ">= 3.2"
end
