# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'req/version'

Gem::Specification.new do |spec|
  spec.name          = "req"
  spec.version       = Req::VERSION
  spec.authors       = ["Christopher Erin"]
  spec.email         = ["chris.erin@gmail.com"]
  spec.description   = %q{cmd line rails request and js repl}
  spec.summary       = %q{cmd line rails request and js repl}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ['req'] #spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'diffy'
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
