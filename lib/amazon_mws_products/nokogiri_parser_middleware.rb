require 'faraday_middleware/response_middleware'

module AmazonMwsProducts
  class NokogiriParserMiddleware < ::FaradayMiddleware::ResponseMiddleware
    dependency 'nokogiri'

    define_parser do |body|
      ::Nokogiri::XML(body)
    end
  end
end

Faraday.register_middleware :response,
  :nokogiri_parser => lambda { AmazonMwsProducts::NokogiriParserMiddleware}
