class Client::EventSessionsController < ApplicationController
  include AttendeeLoader
  include WebApiRenderer
  attr_accessor :meta

  before_action :load_attendee
  layout 'client'

  def index
    self.meta = params

    if params[:format]=='json'
      event = Event.find_by(id: params[:event_id])
      render_not_found '活动id不存在' and return if event.blank?

      collection = []
      event.sessions.each do |session|
        collection << session.to_hash
      end
      render_not_found '会议日程为空' and return if collection.blank?
      render_ok collection
      return
    end

    @sessions = current_event.sessions

    @collection = []
    last_date = ''
    current_event.sessions.each do |session|
      item = {}
      if last_date!=session.start_date
        last_date=session.start_date
        item[:start_date] = session.start_date
        item[:count] = 1
      else
        @collection.each do |item|
          if session.start_date==item[:start_date]
            item[:count] += 1
          end
        end
      end
      @collection << item if item.present?
    end
  end

  def show
    self.meta = params

    @sessions = current_event.sessions

    @collection = []
    last_date = ''
    current_event.sessions.each do |session|
      item = {}
      if last_date!=session.start_date
        last_date=session.start_date
        item[:start_date] = session.start_date
        item[:count] = 1
      else
        @collection.each do |item|
          if session.start_date==item[:start_date]
            item[:count] += 1
          end
        end
      end
      @collection << item if item.present? 
    end
  end

end
