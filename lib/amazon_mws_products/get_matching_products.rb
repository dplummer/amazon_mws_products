module AmazonMwsProducts
  class GetMatchingProducts
    attr_reader :account, :asins

    def initialize(options)
      @account = options.fetch(:account)
      @asins   = options.fetch(:asins)
    end

    def execute
      Client.new(account, 'GetMatchingProduct').get(asin_params)
    end

    private
    def asin_params
      params = {}
      asins.each_with_index do |asin, i|
        params["ASINList.ASIN.#{i+1}"] = asin
      end
      params
    end
  end
end
