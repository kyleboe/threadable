# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "threadable/version"

Gem::Specification.new do |s|
  s.name          = "threadable"
  s.summary       = 'Threadable Event Generator for Rails'
  s.version       = Threadable::VERSION.dup
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Kyle Boe"]
  s.email         = ["kyle@boe.codes"]
  s.homepage      = "https://github.com/kyleboe/threadable"
  s.license       = "MIT"

  s.files         = Dir["app/**/*", "CHANGELOG.md", "README.md"]
  s.require_paths = ["lib"]
  s.required_ruby_version = '>=2.6.0'

  s.add_dependency("orm_adapter", "~> 0.5.0")
  s.add_dependency("railties", ">= 4.2.0", "< 6.0")

  s.add_development_dependency "bundler", "~> 2.0"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 3.0"
end
