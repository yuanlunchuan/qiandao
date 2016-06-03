class EventLotteryPrizesController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module

  layout 'event'

  def lottery_prize_rule
    
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
