# Shopify Product Sync Application

A Ruby on Rails application that synchronizes products from a JSON file to Shopify and handles order creation webhooks.

## Features

- Product synchronization with Shopify
- Hourly background job for product updates
- Order creation webhook handling
- Secure HMAC verification for webhooks
- File-based order storage
- Comprehensive test coverage

## Prerequisites

- Ruby 3.2.0 or higher
- Rails 7.0.0 or higher
- MySQL 8.0 or higher
- Redis 6.0 or higher
- Shopify Partner account and API credentials

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd upload_products_shopify_b
```

2. Install dependencies:
```bash
bundle install
```

3. Configure the database:
```bash
rails db:create
rails db:migrate
```

4. Set up environment variables:
```bash
# .env file
SHOPIFY_API_KEY=your_api_key
SHOPIFY_API_SECRET=your_api_secret
SHOPIFY_SHOP_URL=your_shop_url
SHOPIFY_WEBHOOK_SECRET=your_webhook_secret
```

5. Start Redis:
```bash
brew services start redis
```

## Configuration

### Shopify API Configuration
The application uses the Shopify API for product synchronization. Configure your Shopify credentials in `config/initializers/shopify.rb`:

```ruby
ShopifyAPI::Context.activate_session(
  ShopifyAPI::Session.new(
    shop_url: ENV['SHOPIFY_SHOP_URL'],
    access_token: ENV['SHOPIFY_API_KEY']
  )
)
```

### Sidekiq Configuration
Background jobs are handled by Sidekiq. Configuration is in `config/initializers/sidekiq.rb`:

```ruby
Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
end
```

### Scheduler Configuration
Hourly product synchronization is configured in `config/sidekiq.yml`:

```yaml
:scheduler:
  :schedule:
    shopify_sync:
      cron: '0 * * * *'  # Every hour
      class: ShopifySyncJob
      queue: default
```

## Usage

### Starting the Application

1. Start the Rails server:
```bash
rails server
```

2. Start Sidekiq:
```bash
bundle exec sidekiq -C config/sidekiq.yml
```

### API Endpoints

#### Product Synchronization
- **Endpoint**: `POST /products/sync`
- **Description**: Manually trigger product synchronization
- **Response**: JSON with sync status

#### Order Webhook
- **Endpoint**: `POST /webhooks/orders/create`
- **Description**: Handle Shopify order creation webhooks
- **Headers Required**:
  - `Content-Type: application/json`
  - `X-Shopify-Hmac-SHA256: <hmac_signature>`
- **Response**: JSON with order processing status

### File Storage

Order data is stored in JSON files under `storage/orders/` with the following structure:
```json
{
  "order_id": "123456789",
  "email": "customer@example.com",
  "created_at": "2024-05-21T12:00:00Z",
  "total_price": "99.99",
  "currency": "USD",
  "financial_status": "paid",
  "line_items": [
    {
      "line_item_id": "987654321",
      "title": "Product Name",
      "price": "99.99",
      "quantity": 1,
      "sku": "SKU123"
    }
  ]
}
```

## Testing

Run the test suite:
```bash
rails test
```

The test suite includes:
- Model tests
- Job tests
- Controller tests
- Integration tests

## Security

- CSRF protection is disabled for webhook endpoints
- HMAC verification for all webhook requests
- Environment variables for sensitive data
- Secure file storage for order data

## Error Handling

The application includes comprehensive error handling for:
- Invalid JSON data
- HMAC verification failures
- File system errors
- API communication errors
- Database errors

## Logging

Logs are stored in `log/` directory:
- `development.log` for development environment
- `test.log` for test environment
- `production.log` for production environment

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue in the GitHub repository or contact the development team.

## Acknowledgments

- Shopify API
- Sidekiq
- Ruby on Rails
- Redis
