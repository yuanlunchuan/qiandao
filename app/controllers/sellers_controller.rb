class SellersController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module

  layout 'event'

  def index
    @sellers = current_event.sellers
  end

  def create
    @seller = current_event.sellers.new(seller_params)

    if params[:seller_manager_name].present?
      @seller_manager = Seller.seller_name_is(params[:seller_manager_name]).first
      if @seller_manager.blank?
        @seller_manager_name = params[:seller_manager_name]
        flash.now[:error] = '没有找到对应的对接人, 请重新输入'
        render :new
        return
      else
        @seller.manager = @seller_manager
      end
    end

    if @seller.save
      redirect_to event_sellers_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @seller.errors.full_messages
      render :new
    end
  end

  def destroy
    @seller = current_event.sellers.find(params[:id])
    @seller.destroy

    redirect_to event_sellers_path
  end

  def update
    @seller = current_event.sellers.find(params[:id])

    if @seller.update(seller_params)
      @seller_manager = nil

      if params[:seller_manager_name].present?
        @seller_manager = Seller.seller_name_is(params[:seller_manager_name]).first
        if @seller_manager.blank?
          @seller_manager_name = params[:seller_manager_name]
          flash.now[:error] = '没有找到对应的对接人, 请重新输入'
          render :edit
          return
        end
      end
      @seller.manager = @seller_manager
      @seller.save
      redirect_to event_sellers_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @seller.errors.full_messages
      render :edit
    end
  end

  def edit
    @seller = current_event.sellers.find(params[:id])
    @seller_manager_name = @seller.manager.try(:name)
  end

  def new
    @seller = current_event.sellers.build
  end

  def seller_params
    params.require(:seller).permit(:name, :responsible_area, :phone_number)
  end

  def set_current_module
    @current_module = 5
  end

  private :set_current_module, :seller_params

end
