class LotteryPrizesController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module

  layout 'event'
  def index
    
  end

  def live_lottery_prize
    render layout: 'empty'
  end

  def new

  end

  def create
    attendee = Attendee.find params[:attendee_id]
    event_lottery_prize_item = EventLotteryPrizeItem.find params[:event_lottery_prize_item_id]
    event_lottery_prize = EventLotteryPrize.find params[:event_lottery_prize_id]
    lottery_prize = LotteryPrize.create event: current_event,
      attendee: attendee,
      event_lottery_prize_item: event_lottery_prize_item,
      event_lottery_prize: event_lottery_prize

    event_lottery_prize_item.update count: (event_lottery_prize_item.count-1)

    render status: 'success', json: lottery_prize
  end

  def lottery_prize_setting
    
  end

  def set_current_module
    @current_module = 4
  end

  private :set_current_module

end
