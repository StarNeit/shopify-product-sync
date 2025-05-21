ShopifyAPI::Context.setup(
  api_key: '',
  api_secret_key: '',
  host: '',
  scope: 'write_products,read_products,write_orders,read_orders',
  api_version: '2025-01',
  is_private: true,
  is_embedded: false
)

# Create a session for the private app
session = ShopifyAPI::Auth::Session.new(
  shop: '',
  access_token: ''
)

# Activate the session
ShopifyAPI::Context.activate_session(session) 