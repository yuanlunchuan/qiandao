class Seller::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  layout 'client'
  def create
    sellers = Seller.seller_name_is(params[:seller_name])
    sellers.each do |seller|
      if seller.phone_number[7,10]==params[:phone_number]
        if params[:remember_me]
          cookies.permanent[:seller_id] = seller.id
        else
          cookies[:seller_id] = seller.id
        end
          
        cookies[:event_id]=params[:event_id]
        redirect_to seller_event_activities_path(params[:event_id])
        return
      end
    end

    redirect_to new_seller_event_session_path params[:event_id], flash: {error: '该用户不存在请重新输入'}
  end

  #get请求进行退出
  def show
    cookies.delete(:seller_id)
    redirect_to new_seller_event_session_path params[:event_id]
  end

  def new
    if cookies[:seller_id].present?&&cookies[:event_id]==params[:event_id]
      seller = Seller.find_by(id: cookies[:seller_id])
      if seller.present?
        redirect_to seller_event_activities_path(params[:event_id])
      end
    end
  end

end
