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
    if params[:format]=='json'
      seller = Seller.find(session[:seller_id])
      collection = []

      @session = current_event.sessions.find(params[:session_id])
      @attendees = seller.attendees.seller_is(seller)
      @attendees = @session.attendees.seller_is(seller).unscope(:order).order(checked_in_at: :desc) if params[:state] == 'checked'
      @attendees = current_event.attendees.seller_is(seller).where.not(id: @session.attendees.pluck(:id)) if params[:state] == 'not_checked'

      
      total = current_event.attendees.seller_is(seller).count
      unchecked_in_numbers = current_event.attendees.seller_is(seller).where.not(id: @session.attendees.pluck(:id)).count
      checked_in_numbers = total-unchecked_in_numbers

      @attendees.each do |attendee|
        collection << attendee.to_hash
      end

      collection << { unchecked_in_numbers: unchecked_in_numbers, checked_in_numbers: checked_in_numbers }

      render_ok collection and return if collection.present?
      render_not_found '嘉宾为空'
    end
  end

  def create
    
  end
end
