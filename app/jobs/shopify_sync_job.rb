class ShopifySyncJob < ApplicationJob
  queue_as :default

  def perform
    # Fetch all products from Shopify
    products = ShopifyAPI::Product.all

    products.each do |shopify_product|
      # Get the first variant for price and SKU
      variant = shopify_product.variants.first
      
      # Create or update the product
      product = Product.find_or_initialize_by(shopify_id: shopify_product.id.to_s)
      
      product.assign_attributes(
        title: shopify_product.title,
        description: shopify_product.body_html,
        price: variant&.price,
        sku: variant&.sku,
        status: shopify_product.status
      )

      # Save the product
      product.save!
    end
  end
end 