class ProductsController < ApplicationController
  before_action :fetch_home_data

  def show
    @product = Product.find(params[:id])
  end

  def search
    @products = Product.where("title LIKE ?", "%#{params[:w]}%")
                       .order("id DESC")
                       .includes(:main_product_image)

    unless params[:category_id].blank?
      @products = @products.where(category_id: params[:category_id])
    end

    render "welcome/index"
  end
end
