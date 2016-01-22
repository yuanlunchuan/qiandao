class SeatsController < ApplicationController
  layout 'event'

  def new
    @session = Session.find(params[:session_id])
    if params[:session_id]
      params[:has_photo]  ||= '0'
      params[:has_avatar] ||= '0'
      @attendees = current_event.attendees
      @attendees = @attendees.category(params[:category_id]) if params[:category_id].present?
      @attendees = @attendees.has_photo if params[:has_photo] == '1'
      @attendees = @attendees.has_avatar if params[:has_avatar] == '1'
      @attendees = @attendees.does_not_have_photo  if params[:has_photo] == '-1'
      @attendees = @attendees.does_not_have_avatar if params[:has_avatar] == '-1'
      @attendees = @attendees.does_not_processed_avatar if params[:has_avatar] == '-2'
      @attendees = @attendees.contains(params[:keyword]) if params[:keyword].present?
      @attendees = @attendees.page(params[:page]).includes(:category)
    end
  end

  def index
    
  end

  def show

  end

  def create
    session = Session.find(params[:session_id])

    if session.seat.present?
      session.seat.update table_num: params[:table_num], per_table_num: params[:table_pernum]
    else
      Seat.create table_num: params[:table_num], per_table_num: params[:table_pernum], session: session
    end

    if params[:classify]=='location'&&params[:enable_together]=='no'

       city_list = Attendee.select("city").group("city").reorder('city').size
      city_collection = []

      city_list.each do |k,v|
        city_item = {}
        city_item['city_name'] = k
        city_item['city_count'] = v
        city_collection << city_item
      end
      logger.info "-----city_collection: #{city_collection}"
    end

    redirect_to event_seat_path(current_event, '12', { table_num: params[:table_num], table_pernum: params[:table_pernum] })

  end

end
