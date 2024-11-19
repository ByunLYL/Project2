class Admin::CategoriesController < Admin::BaseController

  before_action :find_root_categories, only: [:new, :create, :edit, :update]
  before_action :find_category, only: [:edit, :update, :destroy]

  def index
    if params[:id].blank?
      @categories = Category.roots
    else
      @category = Category.find(params[:id])
      @categories = @category.children
    end

    @categories = @categories.page(params[:page] || 1).per_page(params[:per_page] || 10)
      .order(id: "desc")
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params.require(:category).permit!)

    if @category.save
      flash[:notice] = "Save Successfully"
      redirect_to admin_categories_path
    else
      render action: :new
    end
  end

  def edit
    render action: :new
  end

  def update
    @category.attributes = params.require(:category).permit!

    if @category.save
      flash[:notice] = "Modify Successfully"
      redirect_to admin_categories_path
    else
      render action: :new
    end
  end

  def destroy
    if @category.destroy
      flash[:notice] = "Delete Successfully"
      redirect_to admin_categories_path
    else
      flash[:notice] = "Delete Failed"
      redirect_to(request.referer || admin_product_images_path)
    end
  end

  private
  def find_root_categories
    @root_categories = Category.roots.order(id: "desc")
  end

  def find_category
    @category = Category.find(params[:id])
  end

end
