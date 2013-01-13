# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'block/version'

Gem::Specification.new do |gem|
  gem.name          = "block"
  gem.version       = Block::VERSION
  gem.authors       = ["Darron Froese"]
  gem.email         = ["darron@froese.org"]
  gem.description   = %q{Ruby Gem to block bad IP addresses that are requesting URL's you determine are bad.}
  gem.summary       = %q{Ruby Gem to block bad IP addresses that are requesting URL's you determine are bad.}
  gem.homepage      = "https://github.com/darron/block"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency('redis', '>= 3.0.2')
  gem.add_dependency('eventmachine', '>= 0.12.10')
  gem.add_dependency('eventmachine-tail', '>= 0.6.3')
end
