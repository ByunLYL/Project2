class Admin::ProductImagesController < Admin::BaseController

  before_action :find_product

  def index
    @product_images = @product.product_images
  end

  def create
    params[:images].each do |image|
      @product.product_images << ProductImage.new(image: image)
    end

    redirect_to(request.referer || admin_product_images_path)

  end

  def destroy
    @product_image = @product.product_images.find(params[:id])
    if @product_image.destroy
      flash[:notice] = "Delete Successfully"
    else
      flash[:notice] = "Delete Failed"
    end

    redirect_to(request.referer || admin_product_images_path)

  end

  def update
    @product_image = @product.product_images.find(params[:id])
    @product_image.weight = params[:weight]
    if @product_image.save
      flash[:notice] = "Modify Successfully"
    else
      flash[:notice] = "Modify Failed"
    end

    redirect_to(request.referer || admin_product_images_path)

  end

  private
  def find_product
    @product = Product.find params[:product_id]
  end

end