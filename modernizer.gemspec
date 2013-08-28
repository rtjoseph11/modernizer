# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'modernizer/version'

Gem::Specification.new do |spec|
  spec.name          = 'modernizer'
  spec.version       = Modernizer::VERSION
  spec.authors       = ['Tucker Joseph']
  spec.email         = ['rtjoseph11@gmail.com']
  spec.description   = %q{convert hashes based on translations associated with versions}
  spec.summary       = %q{see description}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
