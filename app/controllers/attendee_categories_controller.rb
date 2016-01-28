class AttendeeCategoriesController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module
  layout 'event'

  def index
    @categories = current_event.attendee_categories
  end

  def new
    @category = current_event.attendee_categories.build
  end

  def create
    @category = current_event.attendee_categories.new(category_params)

    if @category.save
      redirect_to event_attendee_categories_path, flash: {success: '添加成功'}
    else
      flash.now[:error] = @category.errors.full_messages
      render :new
    end
  end

  def edit
    @category = current_event.attendee_categories.find(params[:id])
  end

  def update
    @category = current_event.attendee_categories.find(params[:id])

    if @category.update(category_params)
      redirect_to event_attendee_categories_path, flash: {success: '添加成功'}
    else
      flash.now[:error] = @category.errors.full_messages
      render :new
    end
  end

  def destroy
    @category = current_event.attendee_categories.find(params[:id])
    @category.destroy
    redirect_to :back
  end

private

  def set_current_module
    @current_module = 2
  end

  def category_params
    params.require(:attendee_category).permit(:name, :category_color)
  end
end
