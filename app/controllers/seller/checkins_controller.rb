class Seller::CheckinsController < ApplicationController
  include SellerLoader

  before_action :load_seller
  layout 'seller'

  include WebApiRenderer
  attr_accessor :meta

  def show
  
  end

  def index
    self.meta = params
    seller = Seller.find(session[:seller_id])
    collection = []
    @attendees = seller.attendees

    #state=checked state=not_checked

    @attendees.each do |attendee|
      collection << attendee.to_hash
    end

    if params[:format]=='json'
      render_ok collection and return if collection.present?
      render_not_found '嘉宾为空'
    end
  end

  def create
    
  end
end
