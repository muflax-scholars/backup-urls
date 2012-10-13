# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'backup-urls/version'

Gem::Specification.new do |gem|
  gem.name          = "backup-urls"
  gem.version       = BackupUrls::VERSION
  gem.authors       = ["muflax"]
  gem.email         = ["mail@muflax.com"]
  gem.description   = %q{backup urls}
  gem.summary       = %q{backup urls}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'parallel'
end
