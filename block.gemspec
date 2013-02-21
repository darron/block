# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','block','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'block'
  s.version = Block::VERSION
  s.author = 'Darron Froese'
  s.email = 'darron@froese.org'
  s.homepage = 'https://github.com/darron/block'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Ruby Gem to block IP addresses that are requesting URLs you determine are bad.'
# Add your other files here if you make them
  s.files = %w(
bin/block
lib/block/version.rb
lib/block/reader.rb
lib/block.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','block.rdoc']
  s.rdoc_options << '--title' << 'block' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'block'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency('foreman')
  s.add_runtime_dependency('gli','2.5.4')
  s.add_runtime_dependency('redis','~> 3.0.0')
  s.add_runtime_dependency('eventmachine','>= 1.0.0')
  s.add_runtime_dependency('eventmachine-tail','~> 0.6.4')
end
