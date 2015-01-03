# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spank/version'

Gem::Specification.new do |spec|
  spec.name          = "spank"
  spec.version       = Spank::VERSION
  spec.authors       = ["mo khan"]
  spec.email         = ["mo@mokhan.ca"]
  spec.description   = %q{A lightweight ruby inversion of control (IOC) container}
  spec.summary       = %q{spank!}
  spec.homepage      = "https://github.com/mokhan/spank"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", '~> 10.4'
  spec.add_development_dependency "rspec", '~> 3.1'
  spec.add_development_dependency "simplecov", '~> 0.9'
  spec.add_development_dependency "codeclimate-test-reporter"
end
