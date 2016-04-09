module MwsHelper
  class MWS
    def self.update_price_and_stock merchant
      return unless merchant.present? && merchant.status && merchant.merchant_plantform_name == 'amazon'

      timestamp = Time.now.utc.iso8601
      signature_version = 2
      version = "2009-01-01"
      purge_and_replace = false

      action = 'SubmitFeed'
      # feed_type = '_POST_PRODUCT_PRICING_DATA_'
      feed_type = '_POST_INVENTORY_AVAILABILITY_DATA_'
      signature_method = 'HmacSHA256'

      mws_auth_token = 'amzn.mws.00a6b69e-25bd-a583-e723-895d0e07ab48'
      aws_access_key_id = merchant.merchant_aws_access_key_id
      seller_id = merchant.merchant_seller_id
      secret_key = merchant.merchant_secret_key
      base_address = merchant.merchant_api_address

      sign_body = "AWSAccessKeyId=#{aws_access_key_id}&Action=#{action}&FeedType=#{feed_type}&MWSAuthToken=#{mws_auth_token}&Merchant=#{seller_id}&PurgeAndReplace=#{purge_and_replace}&SignatureMethod=#{signature_method}&SignatureVersion=#{signature_version}&Timestamp=#{timestamp}&Version=#{version}"
      base_address_content = base_address[base_address.index('//')+2..-1]
      sign_header = "POST\n#{base_address_content}\n/\n"
      sign_url = sign_header + sign_body.gsub!(':', '%3A')
      base_url = "#{base_address}/?#{sign_body}"
      signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secret_key, sign_url)).strip()
      base_url2 = base_url + "&Signature=#{signature.gsub('=','%3D').gsub('+','%2B')}"

        # <MessageType>Price</MessageType>
        # <Message>
        #   <MessageID>1</MessageID>
        #   <Price>
        #     <SKU> 332384 </SKU>
        #     <StandardPrice currency='USD'> 99.299 </StandardPrice>
        #   </Price>
        # </Message>
        # <Message>
        #   <MessageID>2</MessageID>
        #   <Price>
        #     <SKU> 332390 </SKU>
        #     <StandardPrice currency='USD'> 99.199 </StandardPrice>
        #   </Price>
        # </Message>

      xml_body = "<?xml version='1.0' encoding='utf-8' ?>
      <AmazonEnvelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:noNamespaceSchemaLocation='amznenvelope.xsd'>
        <Header>
          <DocumentVersion>1.01</DocumentVersion>
          <MerchantIdentifier>M_SELLER_354577</MerchantIdentifier>
        </Header>
        <MessageType>Inventory</MessageType>
        <Message>
          <MessageID>1</MessageID>
          <OperationType>Update</OperationType>
          <Inventory>
            <SKU> 332384 </SKU>
            <Quantity>88</Quantity>
            <FulfillmentLatency>1</FulfillmentLatency>
          </Inventory>
        </Message>
        <Message>
          <MessageID>2</MessageID>
          <OperationType>Update</OperationType>
          <Inventory>
            <SKU> 332390 </SKU>
            <Quantity>99</Quantity>
            <FulfillmentLatency>1</FulfillmentLatency>
          </Inventory>
        </Message>
      </AmazonEnvelope>"

      url = URI.parse(base_url2)
      md5_header = Digest::MD5.base64digest xml_body
      request = Net::HTTP::Post.new(url, 'Content-MD5' => md5_header, 'Content-Type' => 'text/xml')
      request.body = xml_body
      response = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http| http.request(request)}
      puts response.body
      binding.pry
    end
  end
end