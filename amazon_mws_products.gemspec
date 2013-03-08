# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'amazon_mws_products/version'

Gem::Specification.new do |gem|
  gem.name          = "amazon_mws_products"
  gem.version       = AmazonMwsProducts::VERSION
  gem.authors       = ["Donald Plummer"]
  gem.email         = ["donald@cideasphere.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'faraday'
  gem.add_dependency 'faraday_middleware'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'multi_xml'

  gem.add_development_dependency 'rspec', '~> 2.9.0'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'timecop'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'pry'
end
