# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'monads/version'

Gem::Specification.new do |spec|
  spec.name          = 'monads'
  spec.version       = Monads::VERSION
  spec.authors       = ['Oldrich Vetesnik']
  spec.email         = ['oldrich.vetesnik@gmail.com']
  spec.summary       = 'Some common monads implemented in Ruby.'
  spec.description   = 'Some common monads implemented in Ruby. ' \
                       'Inspired by Tom Stuart.'
  spec.homepage      = 'https://github.com/ollie/monads-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  # System
  spec.add_development_dependency 'bundler', '~> 1.7'

  # Test
  spec.add_development_dependency 'rspec',     '~> 3.1'
  spec.add_development_dependency 'simplecov', '~> 0.9'

  # Code style, debugging, docs
  spec.add_development_dependency 'yard',       '~> 0.8'
  spec.add_development_dependency 'rake',       '~> 10.3'
  spec.add_development_dependency 'rubocop',    '~> 0.26'
  spec.add_development_dependency 'pry',        '~> 0.10'
end
