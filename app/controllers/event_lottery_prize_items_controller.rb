class EventLotteryPrizeItemsController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module
  before_action :load_event_lottery_prize

  layout 'event'

  def specify_attendee_lottery
    @event_lottery_prize = EventLotteryPrize.find(params[:event_lottery_prize_id])
    @event_lottery_prize_item = EventLotteryPrizeItem.find(params[:event_lottery_prize_item_id])
    @lottery_prizes = @event_lottery_prize_item.lottery_prizes.is_specify
  end

  def add_specify_attendee_lottery
    @attendees = current_event.attendees.contains params[:attendee_name]
    @event_lottery_prize = EventLotteryPrize.find(params[:event_lottery_prize_id])
    @event_lottery_prize_item = EventLotteryPrizeItem.find(params[:event_lottery_prize_item_id])

    if @attendees.present?
      lottery_prize = LotteryPrize.create event: current_event,
        attendee: @attendees.first,
        event_lottery_prize_item: @event_lottery_prize_item,
        event_lottery_prize: @event_lottery_prize,
        is_specify: true
      redirect_to event_event_lottery_prize_event_lottery_prize_item_specify_attendee_lottery_path(current_event, @event_lottery_prize, @event_lottery_prize_item), flash: { success: '添加成功' }
    else
      redirect_to event_event_lottery_prize_event_lottery_prize_item_specify_attendee_lottery_path(current_event, @event_lottery_prize, @event_lottery_prize_item), flash: { error: '没有找到对应的信息' }
    end
  end

  def remove_specify_attendee_lottery
    @event_lottery_prize_item = EventLotteryPrizeItem.find(params[:event_lottery_prize_item_id])
    @attendee = Attendee.find params[:attendee_id]
    @event_lottery_prize = EventLotteryPrize.find(params[:event_lottery_prize_id])
    @lottery_prize = @event_lottery_prize_item.lottery_prizes.attendee_is(@attendee)
    if @lottery_prize.first.state=='C'
      @lottery_prize.first.destroy
    else
      @lottery_prize.first.update is_specify: false
    end
    redirect_to event_event_lottery_prize_event_lottery_prize_item_specify_attendee_lottery_path(current_event, @event_lottery_prize, @event_lottery_prize_item), flash: { success: '移除成功' }
  end

  def load_event_lottery_prize
    @event_lottery_prize = EventLotteryPrize.find(params[:event_lottery_prize_id])
  end

  def new
    @event_lottery_prize_item = @event_lottery_prize.event_lottery_prize_items.build
  end

  def create
    @event_lottery_prize_item = @event_lottery_prize.event_lottery_prize_items.new event_lottery_prize_item_params
    if @event_lottery_prize_item.save
      redirect_to event_event_lottery_prize_path(current_event, @event_lottery_prize), flash: { success: '保存成功'}
    else
      flash.now[:error] = @event_lottery_prize_item.errors.full_messages
      render :new
    end
  end

  def edit
    @event_lottery_prize_item = EventLotteryPrizeItem.find params[:id]
  end

  def update
    @event_lottery_prize_item = EventLotteryPrizeItem.find params[:id]
    if @event_lottery_prize_item.update event_lottery_prize_item_params
      redirect_to event_event_lottery_prize_path(current_event, @event_lottery_prize), flash: { success: '保存成功'}
    else
      flash.now[:error] = @event_lottery_prize_item.errors.full_messages
      render :new
    end
  end

  def destroy
    @event_lottery_prize_item = EventLotteryPrizeItem.find params[:id]
    @event_lottery_prize_item.destroy
    redirect_to event_event_lottery_prize_path(current_event, @event_lottery_prize), flash: { success: '删除成功'}
  end

  def event_lottery_prize_item_params
    params.require(:event_lottery_prize_item).permit(:name, :count)
  end

  def set_current_module
    @current_module = 4
  end

  private :set_current_module
end
