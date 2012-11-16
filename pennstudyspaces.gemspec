# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pennstudyspaces/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = "Matt Parmett"
  gem.email         = "mparmett@wharton.upenn.edu"
  gem.description   = %q{Ruby wrapper for the Penn Study Spaces API}
  gem.summary       = %q{Ruby wrapper for the Penn Study Spaces API}
  gem.homepage      = "http://github.com/mattparmett/pennstudyspaces"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pennstudyspaces"
  gem.require_paths = ["lib"]
  gem.version       = PennStudySpaces::Ruby::VERSION
  
  gem.add_dependency "json"
end
