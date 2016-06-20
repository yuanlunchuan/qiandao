class EventLotteryPrizesController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module
  include WebApiRenderer
  attr_accessor :meta

  layout 'event'

  def start_lottery_prize
    @event_lottery_prize = current_event.event_lottery_prizes.find(params[:event_lottery_prize_id])
    @event_lottery_prize_items = @event_lottery_prize.event_lottery_prize_items
    @total_attendee_count = current_event.attendees.size
    @attendees = Attendee.has_lottery_prize(@event_lottery_prize)
    render layout: 'empty'
  end

  def get_attendee_list
    self.meta = params
    @event_lottery_prize = EventLotteryPrize.find params[:event_lottery_prize_id]

    collection = []
    minimum_id = current_event.attendees.first.id
    maximum_id = current_event.attendees.last.id
    last_attendee_id = -1
    for i in 0..20
      attendee_id = rand(minimum_id..maximum_id)
      find = true
      while find
        if last_attendee_id != attendee_id
          find = false
          last_attendee_id = attendee_id
        else
          attendee_id = rand(minimum_id..maximum_id)
        end
      end
      attendee = Attendee.find attendee_id
      item = {}
      item = attendee.to_hash
      img = if attendee.avatar.exists?
           attendee.avatar.url
         else
           attendee.photo.url(:square)
         end
      item['img_url'] = img
      collection << item
    end

    @event_lottery_prize_item = EventLotteryPrizeItem.find(params[:lottery_prize_item])
    @lottery_prizes =  LotteryPrize.event_lottery_prize_item_unfinished(@event_lottery_prize_item)

    if @lottery_prizes.present?
      attendee = @lottery_prizes.first.attendee
    else
      specify_attendees = @event_lottery_prize_item.lottery_prizes.is_specify
      if specify_attendees.present?&&@event_lottery_prize.allow_attendee_repeat_take_in
        attendee_index = rand(0...specify_attendees.size)
        attendee = specify_attendees[attendee_index].attendee
      end
      if "attendee"==@event_lottery_prize.lottery_prize_method
        @event_lottery_prize.lottery_prize_categories
      end
    end

    item = {}
    item = attendee.to_hash
    img = if attendee.avatar.exists?
         attendee.avatar.url
       else
         attendee.photo.url(:square)
       end
    item['img_url'] = img
    collection << item

    render_ok collection
  end

  def get_special_attendee
    
  end

  def lottery_prize_rule
    @categories = current_event.attendee_categories
    @event_lottery_prize = EventLotteryPrize.find(params[:event_lottery_prize_id])
    @lottery_prize_categories = @event_lottery_prize.lottery_prize_categories
    @lottery_prize_category_ids = []
    @lottery_prize_categories.each do |lottery_prize_category|
      @lottery_prize_category_ids << lottery_prize_category.attendee_category.id
    end
  end

  def update_lottery_prize_rule
    @event_lottery_prize = EventLotteryPrize.find params[:event_lottery_prize_id]
    if params[:allow_attendee_repeat_take_in].present?
      @event_lottery_prize.update allow_attendee_repeat_take_in: true
    else
      @event_lottery_prize.update allow_attendee_repeat_take_in: false
    end
    @event_lottery_prize.update lottery_prize_method: params[:lottery_prize_method]
    @lottery_prize_categories = @event_lottery_prize.lottery_prize_categories

    @lottery_prize_categories.delete_all

    params[:category_id].present? && params[:category_id].each_with_index do |category_id, index|
      attendee_category = AttendeeCategory.find params[:category_id][index]
      LotteryPrizeCategory.create event_lottery_prize: @event_lottery_prize, attendee_category: attendee_category
    end
    redirect_to event_event_lottery_prize_lottery_prize_rule_path(current_event, @event_lottery_prize), flash: { success: "更新成功" }
  end

  def show
    @event_lottery_prize = current_event.event_lottery_prizes.find(params[:id])
    @event_lottery_prize_items = @event_lottery_prize.event_lottery_prize_items
    @attendees = current_event.attendees
    @attendees = Attendee.has_lottery_prize(@event_lottery_prize) if "has_lottery"==params[:state]
    @attendees = @attendees.contains(params[:keyword]) if params[:keyword].present?
    @attendees = @attendees.page(params[:page]).includes(:category)
  end

  def destroy
    @event_lottery_prize = current_event.event_lottery_prizes.find(params[:id])
    @event_lottery_prize.destroy
    redirect_to event_event_lottery_prizes_path(current_event), flash: {sucess: "删除成功" }
  end

  def index
    @event_lottery_prizes = current_event.event_lottery_prizes
  end

  def edit
    @event_lottery_prize = current_event.event_lottery_prizes.find params[:id]
  end

  def update
    @event_lottery_prize = current_event.event_lottery_prizes.find params[:id]
    if @event_lottery_prize.update(event_lottery_prize_params)
      redirect_to event_event_lottery_prizes_path(current_event), flash: {sucess: "保存成功" }
    else
      flash.now[:error] = @event_lottery_prize.errors.full_messages
      render :edit
    end
  end

  def new
    @event_lottery_prize = current_event.event_lottery_prizes.build
  end

  def create
    @event_lottery_prize = current_event.event_lottery_prizes.new event_lottery_prize_params
    if @event_lottery_prize.save
      redirect_to event_event_lottery_prizes_path, flash: { sucess: "保存成功" }
    else
      flash.now[:error] = @event_lottery_prize.errors.full_messages
      render :new
    end
  end

  def event_lottery_prize_params
    params.require(:event_lottery_prize).permit(:name, :comment)
  end

  def set_current_module
    @current_module = 4
  end

  private :set_current_module, :event_lottery_prize_params

end
