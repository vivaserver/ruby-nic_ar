# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nic_ar/version'

Gem::Specification.new do |gem|
  gem.name          = "nic_ar"
  gem.version       = NicAr::VERSION
  gem.authors       = ["Cristian R. Arroyo"]
  gem.email         = ["cristian.arroyo@vivaserver.com"]
  gem.description   = %q{A simple client for ".ar" (Argentina) domain names lookup}
  gem.summary       = %q{A simple client for ".ar" (Argentina) domain names lookup using the nic!alert API}
  gem.homepage      = "https://github.com/vivaserver/nic_ar"

  gem.add_runtime_dependency 'rest-client', '~> 1.6'
  gem.add_development_dependency 'minitest', '~> 3.3.0'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
