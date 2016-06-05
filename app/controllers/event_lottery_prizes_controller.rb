class EventLotteryPrizesController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module

  layout 'event'

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
