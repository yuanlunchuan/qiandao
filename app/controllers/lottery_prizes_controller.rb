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
    params[:lottery][:lottery_name].each_with_index do |lottery_item, i|
      EventLotteryPrize.create event_id: current_event.id,
        lottery_prize_name: params[:lottery][:lottery_name][i],
        lottery_prize_acount: params[:lottery][:lottery_acount][i]
    end
    redirect_to event_lottery_prize_setting_path(current_event)
  end

  def lottery_prize_setting
    
  end

  def set_current_module
    @current_module = 4
  end

  private :set_current_module

end
