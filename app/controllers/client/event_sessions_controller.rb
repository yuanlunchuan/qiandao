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

    if params[:format]=='json'
      render_ok @collection
    end


=begin    
    self.meta = params
    event = Event.find_by(id: params[:event_id])
    render_not_found '会议日程为空' and return if event.blank?

    @sessions = event.sessions
    collection = []

    @sessions.each do |session|
      collection << session.to_hash
    end

    render_ok collection and return if collection.present?
    render_not_found '会议日程为空'
=end
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

    if params[:format]=='json'
      render_ok @collection
    end


=begin
    collection = []
    current_event.sessions.each do |session|
      start_date = session.start_date
      has_find = false
      item = {}

      collection.each do |collection_item|
        if collection_item[:start_date] == start_date
          has_find = true
          if item[:collection].blank?
            item[:collection] = []
          end
          item[:collection] << session
        end
      end

      if !has_find
        item[:start_date] = start_date
        item[:collection] = []
        item[:collection] << session
      end

      collection << item
      logger.info "---------collection: #{collection}"
    end
    logger.info "++++++++++collection+++++++: #{collection}"
=end

=begin
    current_event.sessions.each do |session|
      starts_at = (session.starts_at-8*60*60).strftime('%Y%m%d').to_i
      has_find = false
      item = {}

      collection.each do |collection_item|
        if collection_item[:starts_at] == starts_at
          has_find = true
          if item[:collection].blank?
            item[:collection] = []
          end
          item[:collection] << session
        end
      end

      if !has_find
        logger.info "-----------------has not find---------------"
        item[:starts_at] = starts_at
        item[:collection] = []
        item[:collection] << session
      end

      collection << item
      logger.info "------collection: #{collection}"
    end
=end

  end

end
