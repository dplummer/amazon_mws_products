%w[AWS_SELLER_ID AWS_ACCESS_KEY_ID AWS_MARKETPLACE_ID AWS_SECRET_ACCESS_KEY].each do |key|
  if !ENV.has_key?(key)
    puts "Configure an environment variable with your #{key}"
    exit(1)
  end
end

require_relative '../lib/amazon_mws_products'
require 'ostruct'
require 'pp'
require 'nokogiri'


account = OpenStruct.new(seller_id:         ENV["AWS_SELLER_ID"],
                         aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
                         marketplace_id:    ENV["AWS_MARKETPLACE_ID"],
                         secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])

client = AmazonMwsProducts::ListMatchingProducts.new(account: account,
                                                     query: "harry potter",
                                                     query_context_id: "DVD")
response = client.execute # response body will be a Nokogiri::XML::Document
puts response.body.to_xml
