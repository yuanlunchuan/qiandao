class Seller::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout 'client'
  def create
    sellers = Seller.seller_name_is(params[:seller_name])
    sellers.each do |seller|
      if (seller.event.id.to_s==params[:event_id].to_s)&&(seller.phone_number[7,10]==params[:phone_number])
        if params[:remember_me]
          cookies.permanent[:seller_id] = seller.id
        else
          cookies[:seller_id] = seller.id
        end

        redirect_to seller_event_activities_path(seller.event.id)
        return
      end
    end

    redirect_to new_seller_event_session_path params[:event_id], flash: {error: '该用户不存在请重新输入'}
  end

  def new
    if cookies[:seller_id].present?
      seller = Seller.find_by(id: cookies[:seller_id])
      if seller.present?&&(seller.event.id.to_s==params[:event_id].to_s)
        redirect_to seller_event_activities_path(seller.event.id)
      end
    end
  end

end
