# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'escapement/version'

Gem::Specification.new do |spec|
  spec.name          = "escapement"
  spec.version       = Escapement::VERSION
  spec.authors       = ["Ryan LeFevre"]
  spec.email         = ["ryan@hodinkee.com"]

  spec.summary       = %q{Extract child entities from an HTML string.}
  spec.description   = %q{Given a HTML formatted string, escapement will extract descendant tags into a device agnostic attributes array that can be used for formatting the text anywhere.}
  spec.homepage      = "https://github.com/hodinkee/escapement"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_dependency "nokogiri", "~> 1.6"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3"
end
