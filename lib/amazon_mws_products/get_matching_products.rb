require 'base64'
require 'cgi'
require 'uri'

module AmazonMwsProducts
  class GetMatchingProducts
    AWS_API_VERSION   = '2011-10-01'
    SIGNATURE_VERSION = '2'
    SIGNATURE_METHOD  = 'HmacSHA256'
    AWS_ACTION        = 'GetMatchingProduct'

    ENDPOINT          = 'mws.amazonservices.com'
    PATH              = '/Products/2011-10-01'

    attr_reader :account, :asins

    def initialize(account, asins)
      @account = account
      @asins = asins
    end

    def execute
      RestClient.get(endpoint_url_with_query)
    end

    private
    def endpoint_url_with_query
      URI::HTTPS.build(:host  => ENDPOINT,
                       :path  => PATH,
                       :query => to_query(params)).to_s

    end

    def to_query(hash)
      hash.map {|k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"}.join('&')
    end

    def params
      params = {
        'AWSAccessKeyID'   => account.aws_access_key_id,
        'Action'           => AWS_ACTION,
        'SellerId'         => account.seller_id,
        'Timestamp'        => Time.now.utc.xmlschema,
        'Version'          => AWS_API_VERSION,
        'MarketplaceId'    => account.marketplace_id
      }

      asins.each_with_index do |asin, i|
        params["ASINList.ASIN.#{i+1}"] = asin
      end

      sign_params(:get, account.secret_access_key, params)
    end

    def sign_params(http_verb, secret_key, params)
      full_params = params.merge({"SignatureVersion" => SIGNATURE_VERSION,
                                  "SignatureMethod"  => SIGNATURE_METHOD })
      digest = Digest::HMAC.digest(serialized_params(full_params, http_verb),
                                    secret_key,
                                    Digest::SHA256)
      # chomp -- the base64 encoded version will have a newline at the end
      full_params["Signature"] = Base64.encode64(digest).chomp
      full_params
    end

    def serialized_params(params, http_verb)
      [ http_verb.to_s.upcase,
        ENDPOINT,
        PATH,
        canonicalize_params(params) ].join("\n")
    end

    def canonicalize_params(params)
      # Make sure we have string keys, otherwise the sort does not work
      params.inject({}) {|acc, (k,v)| acc[k.to_s] = v; acc}.sort.map do |key, value|
        [CGI.escape(key), CGI.escape(value.to_s)].join('=')
      end.join('&')
    end

  end
end
