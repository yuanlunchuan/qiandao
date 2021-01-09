class RestaurantsController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module

  layout 'event'

  def edit
    @restaurant = Restaurant.find_or_create_by(event: current_event)
    @latitude = @restaurant.latitude
    @longitude = @restaurant.longitude
  end

  def update
    @restaurant = Restaurant.find(params[:id])

    if @restaurant.update(restaurant_param)
      @restaurant.latitude = params[:latitude]
      @restaurant.longitude = params[:longitude]
      @restaurant.save
      redirect_to event_content_setting_path(current_event), flash: {success: '保存成功'}
    else
      flash.now[:error] = @restaurant.errors.full_messages
      render :edit
    end
  end

  def restaurant_param
    params.require(:restaurant).permit(:restaurant_name, :phone_number, :address, :map_url, :head_photo)
  end

  def set_current_module
    @current_module = 6
  end

end