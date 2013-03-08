# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'amazon_mws_products/version'

Gem::Specification.new do |gem|
  gem.name          = "amazon_mws_products"
  gem.version       = AmazonMwsProducts::VERSION
  gem.authors       = ["Donald Plummer", "Michael Xavier"]
  gem.email         = ["donald.plummer@gmail.com", "michael@michaelxavier.net"]
  gem.description   = %q{A client for AmazonMWS Products API}
  gem.summary       = %q{A client for AmazonMWS Products API}
  gem.homepage      = "https://github.com/dplummer/amazon_mws_products"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'faraday'
  gem.add_dependency 'faraday_middleware'
  gem.add_dependency 'nokogiri'

  gem.add_development_dependency 'rspec', '~> 2.9.0'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'timecop'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'pry'
end
