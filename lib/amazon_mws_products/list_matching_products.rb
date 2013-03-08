module AmazonMwsProducts
  class ListMatchingProducts
    attr_reader :account, :query, :query_context_id

    def initialize(account, query, query_context_id = nil)
      @account = account
      @query = query
      @query_context_id = query_context_id
    end

    def execute
      params = { "Query" => URI.encode(query) }
      params["QueryContextId"] = query_context_id if query_context_id
      client.get(params)
    end

    def client
      Client.new(account, 'ListMatchingProducts')
    end
  end
end
