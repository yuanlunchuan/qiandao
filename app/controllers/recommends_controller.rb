class RecommendsController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module

  layout 'event'

  def new
    @recommend = current_event.recommends.build
  end

  def index
    @recommends = current_event.recommends
  end

  def create
    @recommend = current_event.recommends.new recommend_params

    if @recommend.save
      redirect_to event_recommends_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @recommend.errors.full_messages
      render :new
    end
  end

  def update
    @recommend = current_event.recommends.find(params[:id])

    if @recommend.update(recommend_params)
      redirect_to event_recommends_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @recommend.errors.full_messages
      render :edit
    end
  end

  def destroy
    @recommend = current_event.recommends.find(params[:id])
    @recommend.destroy

    redirect_to event_recommends_path
  end

  def edit
    @recommend = current_event.recommends.find(params[:id])
  end

  def set_current_module
    @current_module = 0
  end

  def recommend_params
    params.require(:recommend).permit(:category_name, :recommend_name, :address, :phone_number, :distance)
  end

  private :set_current_module
end
