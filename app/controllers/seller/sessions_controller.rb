class Seller::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout 'client'
  def create
    sellers = Seller.phone_number_is(params[:phone_number])
    if sellers.present?
      cookies.permanent[:seller_id] = sellers.first.id
      redirect_to seller_event_checkins_path(sellers.first.event.id)
    else
      flash.now[:error] = '该用户不存在请重新输入'
      render :new
    end
  end

  def new
    if cookies[:seller_id].present?
      seller = Seller.find_by(id: cookies[:seller_id])
      if seller.present?
        redirect_to seller_event_checkins_path(seller.event.id)
      end
    end
  end

end
