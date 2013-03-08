# AmazonMwsProducts

A client for the AmazonMWS Products API as defined by:

https://images-na.ssl-images-amazon.com/images/G/01/mwsportal/doc/en_US/products/MWSProductsApiReference._V388666043_.pdf

## Installation

Add this line to your application's Gemfile:

    gem 'amazon_mws_products'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install amazon_mws_products

## Usage

```ruby
require 'amazon_mws_products'
require 'ostruct'

account = OpenStruct.new(seller_id:         "your mws seller id",
                         aws_access_key_id: "your mws access key",
                         marketplace_id:    "the marketplace id",
                         secret_access_key: "your secret access key")

client = AmazonMwsProducts::ListMatchingProducts.new(account, "harry potter dvd")
response = client.execute # response body will be a Nokogiri::XML::Document
puts response.body.to_xml
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

AmazonMwsProducts is released under the MIT license:

* http://www.opensource.org/licenses/MIT
