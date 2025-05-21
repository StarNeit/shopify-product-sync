require "test_helper"

class ShopifySyncJobTest < ActiveJob::TestCase
  setup do
    @mock_product = mock
    @mock_variant = mock
    @mock_products = [@mock_product]
  end

  # test "performs product sync" do
  #   # Mock ShopifyAPI::Product.all
  #   ShopifyAPI::Product.expects(:all).returns(@mock_products)
    
  #   # Mock product attributes
  #   @mock_product.expects(:id).returns(123)
  #   @mock_product.expects(:title).returns("Test Product")
  #   @mock_product.expects(:body_html).returns("Product Description")
  #   @mock_product.expects(:variants).returns([@mock_variant])
  #   @mock_product.expects(:status).returns("active")

  #   # Mock variant attributes
  #   @mock_variant.expects(:price).returns("19.99")
  #   @mock_variant.expects(:sku).returns("SKU123")

  #   # Mock Product creation/update
  #   Product.expects(:find_or_initialize_by).with(shopify_id: "123").returns(Product.new)
  #   Product.any_instance.expects(:save!).returns(true)

  #   # Perform the job
  #   assert_difference -> { Product.count } do
  #     ShopifySyncJob.perform_now
  #   end

  #   # Verify the product was created with correct attributes
  #   product = Product.last
  #   assert_equal "123", product.shopify_id
  #   assert_equal "Test Product", product.title
  #   assert_equal "Product Description", product.description
  #   assert_equal "19.99", product.price
  #   assert_equal "SKU123", product.sku
  #   assert_equal "active", product.status
  # end
end 