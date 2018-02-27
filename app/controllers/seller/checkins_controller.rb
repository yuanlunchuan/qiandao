class Seller::CheckinsController < ApplicationController
  include SellerLoader

  #before_action :load_seller
  layout 'seller'

  include WebApiRenderer
  attr_accessor :meta

  def show

  end

  def index
    self.meta = params
    @seller = Seller.find(session[:seller_id])
    if params[:format]=='json'
      seller = Seller.find(session[:seller_id])
      collection = []

      @session = current_event.sessions.find(params[:session_id])
      @attendees = seller.attendees.seller_is(seller)
      @attendees = @session.attendees.seller_is(seller).unscope(:order).order(checked_in_at: :desc) if params[:state] == 'checked'
      @attendees = current_event.attendees.seller_is(seller).where.not(id: @session.attendees.pluck(:id)) if params[:state] == 'not_checked'
      @attendees = current_event.attendees.seller_is(seller).contains(params[:key_word]) if params[:key_word].present?

      total = current_event.attendees.seller_is(seller).count
      unchecked_in_numbers = current_event.attendees.seller_is(seller).where.not(id: @session.attendees.pluck(:id)).count
      checked_in_numbers = total-unchecked_in_numbers

      @attendees.each do |attendee|
        checkin = Checkin.checkin_is(@session, attendee)
        item = {}
        item = attendee.to_hash
        item[:has_checked] = false
        item[:has_checked] = true if checkin.present?
        item[:checked_in_at] = checkin.first.checked_in_at.to_s if checkin.present?
        collection << item
      end

      collection << { total: total, unchecked_in_numbers: unchecked_in_numbers, checked_in_numbers: checked_in_numbers }

      render_ok collection and return if collection.present?
      render_not_found '嘉宾为空'
    end
  end

  def create
    
  end
end
