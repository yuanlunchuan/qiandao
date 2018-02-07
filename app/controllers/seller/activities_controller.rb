class Seller::ActivitiesController < ApplicationController
  include SellerLoader

  before_action :load_seller
  layout 'seller'

  def show
  
  end

  def index
    @seller = Seller.find(session[:seller_id])
    @sessions = Event.find(params[:event_id]).sessions
  end

end
