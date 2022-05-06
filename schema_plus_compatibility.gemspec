# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'schema_plus/compatibility/version'

Gem::Specification.new do |gem|
  gem.name          = "schema_plus_compatibility"
  gem.version       = SchemaPlus::Compatibility::VERSION
  gem.authors       = ["ronen barzel", "boaz yaniv"]
  gem.email         = ["ronen@barzel.org", "boazyan@gmail.com"]
  gem.summary       = %q{Compatibility helpers for the SchemaPlus family of gems}
  gem.description   = %q{Compatibility helpers for the SchemaPlus family of gems}
  gem.homepage      = "https://github.com/SchemaPlus/schema_plus_compatibility"
  gem.license       = "MIT"

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.required_ruby_version = ">= 2.5.0"

  gem.add_dependency "activerecord", ">= 5.2", "< 7.0"
  gem.add_dependency "schema_monkey", "~> 3.0"

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake", "~> 13.0"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "schema_dev", "~> 4.1"
end
