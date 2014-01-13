# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'requirejs/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby-requirejs'
  spec.version       = Ruby::Requirejs::VERSION
  spec.authors       = ['Alex Krasinsky']
  spec.email         = ['lyoshakr@gmail.com']
  spec.summary       = %q{Ruby/Rails requirejs compiler}
  spec.description   = %q{Support of requirejs in ruby/rails projects}
  spec.homepage      = 'https://github.com/spilin/ruby-requirejs'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', "~> 1.5"
  spec.add_development_dependency 'rake'
end
