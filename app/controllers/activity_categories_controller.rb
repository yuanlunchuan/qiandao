class ActivityCategoriesController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module
  layout 'event'

  def index
    @categories = current_event.activity_categories
  end

  def edit
    @category = current_event.activity_categories.find(params[:id])
  end

  def update
    @category = current_event.activity_categories.find(params[:id])

    if @category.update(category_params)
      redirect_to event_activity_categories_path, flash: {success: '修改成功'}
    else
      flash.now[:error] = @category.errors.full_messages
      render :new
    end
  end

  def new
    @category = current_event.activity_categories.new
  end

  def create
    @category = current_event.activity_categories.new(category_params)

    if @category.save
      redirect_to event_activity_categories_path, flash: {success: '添加成功'}
    else
      flash.now[:error] = @category.errors.full_messages
      render :new
    end
  end

  def destroy
    @category = current_event.activity_categories.find(params[:id])
    @category.destroy
    redirect_to :back
  end

  def set_current_module
    @current_module = 0
  end

  def category_params
    params.require(:activity_category).permit(:name, :category_color)
  end

  private :set_current_module, :category_params

end