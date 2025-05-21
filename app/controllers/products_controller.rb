class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:sync]

  def sync
    ShopifySyncJob.perform_later
    render json: { message: 'Product sync job has been enqueued' }, status: :ok
  end

  def index
    @products = Product.all
    render json: @products
  end
end 