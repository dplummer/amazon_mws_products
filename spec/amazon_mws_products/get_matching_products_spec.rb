require 'spec_helper'

module AmazonMwsProducts
  describe GetMatchingProducts do
    let(:account) do
      OpenStruct.new(:seller_id => 'sellerid',
                     :aws_access_key_id => 'accesskey',
                     :marketplace_id => 'marketplaceid',
                     :secret_access_key => 'secret key')
    end

    let(:asins) {%w{B002QYOP72 B009AWSLFK B008BV6XA6}}

    subject { GetMatchingProducts.new(account, asins) }

    before(:each) do
      stub_request(:get, %r{^https://mws.amazonservices.com/Products/2011-10-01}).
        to_return(:body => "<foo>bar</foo>", :status => 200)
    end

    describe "#execute" do
      it "builds the correct url and request parameters" do
        Timecop.freeze(DateTime.new(2012, 3, 14, 15, 9, 26, Rational(-7,24))) do
          subject.execute

          a_request(:get, "https://mws.amazonservices.com/Products/2011-10-01").
            with(:query => hash_including(
            'AWSAccessKeyId'   => account.aws_access_key_id,
            'Action'           => 'GetMatchingProduct',
            'SellerId'         => account.seller_id,
            'SignatureVersion' => '2',
            'Timestamp'        => '2012-03-14T21:09:26Z',
            'Version'          => '2011-10-01',
            'SignatureMethod'  => 'HmacSHA256',
            'MarketplaceId'    => account.marketplace_id,
            'ASINList.ASIN.1'  => asins[0],
            'ASINList.ASIN.2'  => asins[1],
            'ASINList.ASIN.3'  => asins[2]
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

          sig.should == 'Y42l/KzBlLDfka9hFDx2QwTMJCWQsFoKA68SOgvSWx4='
        end
      end

      it "parses the response" do
        subject.execute.body.at('foo').text.should == 'bar'
      end

    end
  end
end
