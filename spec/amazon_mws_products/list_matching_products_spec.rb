require 'spec_helper'

module AmazonMwsProducts
  describe ListMatchingProducts do
    let(:account) do
      OpenStruct.new(:seller_id => 'sellerid',
                     :aws_access_key_id => 'accesskey',
                     :marketplace_id => 'marketplaceid',
                     :secret_access_key => 'secret key')
    end

    let(:query) { "harry potter dvd" }
    let(:options) {{
      account: account,
      query: query
    }}

    subject { ListMatchingProducts.new(options) }

    before(:each) do
      stub_request(:get, %r{^https://mws.amazonservices.com/Products/2011-10-01}).
        to_return(:body => "resp body", :status => 200)
    end

    describe "#execute" do
      it "builds the correct url and request parameters" do
        Timecop.freeze(DateTime.new(2012, 3, 14, 15, 9, 26, Rational(-7,24))) do
          subject.execute

          a_request(:get, "https://mws.amazonservices.com/Products/2011-10-01").
            with(:query => hash_including(
            'AWSAccessKeyId'   => account.aws_access_key_id,
            'Action'           => 'ListMatchingProducts',
            'SellerId'         => account.seller_id,
            'SignatureVersion' => '2',
            'Timestamp'        => '2012-03-14T21:09:26Z',
            'Version'          => '2011-10-01',
            'SignatureMethod'  => 'HmacSHA256',
            'MarketplaceId'    => account.marketplace_id,
            'Query'            => "harry%20potter%20dvd"
          )).should have_been_made.once
        end
      end

      context "query context id included in request" do
        let(:options) {{
          account: account,
          query: query,
          query_context_id: "Toys"
        }}

        it "adds the proper query parameter" do
          subject.execute

          a_request(:get, "https://mws.amazonservices.com/Products/2011-10-01").
            with(:query => hash_including(
              "Query"          => "harry%20potter%20dvd",
              "QueryContextId" => "Toys"
          )).should have_been_made.once
        end
      end

      it "signs the request" do
        Timecop.freeze(DateTime.new(2012, 3, 14, 15, 9, 26, Rational(-7,24))) do
          subject.execute

          sig = nil
          a_request(:get, %r{https://mws.amazonservices.com/Products/2011-10-01}).with do |req|
            sig = req.uri.query_values['Signature']
            true
          end.should have_been_made

          sig.should == 'kMBqDjSPb8hLxTWAb6Tg6iQYW5huO4qRBgC ZfI86iQ='
        end
      end
    end
  end
end
