require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "should create product with valid attributes" do
    product = Product.new(
      title: "Test Product",
      description: "Test Description",
      price: 99.99,
      status: "active",
      sku: "TEST123"
    )
    assert product.save
  end

  test "should not create product without required attributes" do
    product = Product.new
    assert_not product.save
  end

  test "should not create product with duplicate SKU" do
    Product.create!(
      title: "First Product",
      description: "First Description",
      price: 99.99,
      status: "active",
      sku: "TEST123"
    )

    product = Product.new(
      title: "Second Product",
      description: "Second Description",
      price: 149.99,
      status: "active",
      sku: "TEST123"
    )
    assert_not product.save
  end
end
