module AmazonMwsProducts
  class ListMatchingProducts
    attr_reader :account, :query, :query_context_id

    def initialize(options)
      @account          = options.fetch(:account)
      @query            = options.fetch(:query)
      @query_context_id = options[:query_context_id]
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
