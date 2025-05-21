require "test_helper"

class WebhooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order_data = {
      id: 123456789,
      email: "customer@example.com",
      created_at: "2024-05-21T12:00:00Z",
      total_price: "99.99",
      currency: "USD",
      financial_status: "paid",
      line_items: [
        {
          id: 987654321,
          title: "Product Name",
          price: "99.99",
          quantity: 1,
          sku: "SKU123"
        }
      ]
    }

    # Ensure the orders directory exists and is empty
    @orders_dir = Rails.root.join('storage', 'orders')
    FileUtils.mkdir_p(@orders_dir)
    FileUtils.rm_rf(Dir.glob(@orders_dir.join('*.json')))

    # Set webhook secret for testing
    @webhook_secret = "test_webhook_secret"
    ENV['SHOPIFY_WEBHOOK_SECRET'] = @webhook_secret
  end

  teardown do
    # Clean up test files
    FileUtils.rm_rf(Dir.glob(@orders_dir.join('*.json')))
    # Clean up environment variable
    ENV.delete('SHOPIFY_WEBHOOK_SECRET')
  end

  # test "should create order file" do
  #   # Skip HMAC verification in test environment
  #   Rails.env.stubs(:development?).returns(true)

  #   # Calculate HMAC for the request
  #   data = @order_data.to_json
  #   hmac = OpenSSL::HMAC.digest(
  #     OpenSSL::Digest.new('sha256'),
  #     @webhook_secret,
  #     data
  #   )
  #   hmac_base64 = Base64.strict_encode64(hmac)

  #   # assert_difference -> { Dir.glob(@orders_dir.join('*.json')).count } do
  #   #   post webhooks_orders_create_url, 
  #   #        params: data, 
  #   #        as: :json,
  #   #        headers: { 
  #   #          'Content-Type' => 'application/json',
  #   #          'X-Shopify-Hmac-SHA256' => hmac_base64
  #   #        }
  #   # end

  #   assert_response :success
  #   assert_equal "Order details saved successfully", JSON.parse(response.body)["message"]

  #   # Verify file contents
  #   file_path = @orders_dir.join("order_#{@order_data[:id]}.json")
  #   assert File.exist?(file_path)
  #   saved_data = JSON.parse(File.read(file_path))
  #   assert_equal @order_data[:id].to_s, saved_data["order_id"].to_s
  # end

  # test "should reject invalid json" do
  #   # Skip HMAC verification for invalid JSON test
  #   Rails.env.stubs(:development?).returns(true)

  #   post webhooks_orders_create_url, 
  #        params: "invalid json", 
  #        as: :json,
  #        headers: { 'Content-Type' => 'application/json' }
    
  #   assert_response :bad_request
  #   assert_equal "Invalid JSON", JSON.parse(response.body)["error"]
  # end

  test "should reject invalid webhook" do
    # Enable HMAC verification
    Rails.env.stubs(:development?).returns(false)
    
    # Calculate valid HMAC
    data = @order_data.to_json
    hmac = OpenSSL::HMAC.digest(
      OpenSSL::Digest.new('sha256'),
      @webhook_secret,
      data
    )
    hmac_base64 = Base64.strict_encode64(hmac)
    
    # Set invalid HMAC
    post webhooks_orders_create_url,
         params: data,
         as: :json,
         headers: { 
           'Content-Type' => 'application/json',
           'X-Shopify-Hmac-SHA256' => 'invalid_hmac' 
         }
    
    assert_response :unauthorized
  end
end 