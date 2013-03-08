require 'faraday'
require 'faraday_middleware'
require 'base64'
require 'cgi'
require 'uri'
require 'time'
require 'base64'
require 'openssl'

module AmazonMwsProducts
  class Client
    AWS_API_VERSION   = '2011-10-01'
    SIGNATURE_VERSION = '2'
    SIGNATURE_METHOD  = 'HmacSHA256'
    ENDPOINT          = 'mws.amazonservices.com'
    PATH              = '/Products/2011-10-01'

    attr_reader :account, :action

    def initialize(account, action)
      @account = account
      @action = action
    end

    def get(additional_params)
      make_request(:get, additional_params)
    end

    private

    def make_request(http_verb, additional_params)
      params = request_parameters(http_verb, additional_params)
      resource.send(http_verb, PATH, params)
    end

    def resource
      conn = Faraday.new(:url => uri)
      conn
    end

    def uri
      URI::HTTPS.build(:host  => ENDPOINT).to_s
    end

    def request_parameters(http_verb, additional_params)
      params = default_params.merge(additional_params)

      sign_params(http_verb, account.secret_access_key, params)
    end

    def default_params
      {
        'AWSAccessKeyId'   => account.aws_access_key_id,
        'Action'           => action,
        'SellerId'         => account.seller_id,
        'Timestamp'        => Time.now.utc.xmlschema,
        'Version'          => AWS_API_VERSION,
        'MarketplaceId'    => account.marketplace_id,
      }
    end

    def sign_params(http_verb, secret_key, params)
      full_params = params.merge({"SignatureVersion" => SIGNATURE_VERSION,
                                  "SignatureMethod"  => SIGNATURE_METHOD })
      digest = OpenSSL::HMAC.digest('sha256',
                                    secret_key,
                                    serialized_params(full_params, http_verb))

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
