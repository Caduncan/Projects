class CategoriesController < ApplicationController
  before_action :login_user, except: [:show]
  before_action :admin_role, except: [:show]

  def show
    @category = Category.find_by(slug: params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = "'#{@category.name}' category created."
      redirect_to root_path
    else
      render :new
    end
  end

  private

    def category_params
      params.require(:category).permit(:name)
    end
end