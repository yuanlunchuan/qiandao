class Seller::ActivitiesController < ApplicationController
  include SellerLoader

  #before_action :load_seller
  layout 'seller'

  def show
  
  end

  def index
logger.info "123"
    @seller = Seller.find(cookies[:seller_id])
logger.info "234"
    @sessions = Event.find(params[:event_id]).sessions
logger.info "456"
  end

end
