class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :parse_json, only: [:create]
  before_action :verify_webhook, only: [:create]

  def create
    # Process the webhook data
    order_data = @parsed_json
    
    # Log the order data
    Rails.logger.info "Received order webhook: #{order_data.inspect}"
    
    # Create order details file
    order_details = {
      order_id: order_data['id'],
      email: order_data['email'],
      created_at: order_data['created_at'],
      total_price: order_data['total_price'],
      currency: order_data['currency'],
      financial_status: order_data['financial_status'],
      line_items: order_data['line_items'].map do |item|
        {
          line_item_id: item['id'],
          title: item['title'],
          price: item['price'],
          quantity: item['quantity'],
          sku: item['sku']
        }
      end
    }

    # Create directory if it doesn't exist
    orders_dir = Rails.root.join('storage', 'orders')
    FileUtils.mkdir_p(orders_dir)

    # Save to file
    file_path = orders_dir.join("order_#{order_data['id']}.json")
    File.write(file_path, JSON.pretty_generate(order_details))
    
    render json: { status: 'success', message: 'Order details saved successfully' }, status: :ok
  rescue StandardError => e
    Rails.logger.error "Error processing webhook: #{e.message}"
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end

  private

  def parse_json
    @parsed_json = JSON.parse(request.body.read)
    request.body.rewind # Reset the request body for future reads
  rescue JSON::ParserError => e
    Rails.logger.error "Invalid JSON: #{e.message}"
    render json: { error: 'Invalid JSON' }, status: :bad_request
    false
  end

  def verify_webhook
    return true if Rails.env.development?

    hmac_header = request.headers['X-Shopify-Hmac-SHA256']
    data = request.body.read
    request.body.rewind # Reset the request body for future reads

    unless hmac_header
      render json: { error: 'Missing HMAC header' }, status: :unauthorized
      return false
    end

    # Get your webhook secret from Shopify
    webhook_secret = ENV['SHOPIFY_WEBHOOK_SECRET']

    unless ShopifyWebhookHelper.verify_webhook(data, hmac_header, webhook_secret)
      render json: { error: 'Invalid HMAC' }, status: :unauthorized
      return false
    end

    true
  end
end 