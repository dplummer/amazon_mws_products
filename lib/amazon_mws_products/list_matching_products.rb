module AmazonMwsProducts
  class ListMatchingProducts
    attr_reader :account, :query

    def initialize(account, query)
      @account = account
      @query = query
    end

    def execute
      client.get("Query" => URI.encode(query))
    end

    def client
      Client.new(account, 'ListMatchingProducts')
    end
  end
end
