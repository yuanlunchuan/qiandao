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

    special_lottery_prize_attendees = LotteryPrize.search_by_attendee_and_event_lottery_prize(attendee, event_lottery_prize).where("state='C'")
    if special_lottery_prize_attendees.present?
      special_lottery_prize_attendees.first.update state: 'F'
    else
      lottery_prize = LotteryPrize.create event: current_event,
        attendee: attendee,
        event_lottery_prize_item: event_lottery_prize_item,
        event_lottery_prize: event_lottery_prize,
        state: 'F'
    end
    event_lottery_prize_item.update count: (event_lottery_prize_item.count-1)

    item = {}
    item = attendee.to_hash
    img = if attendee.avatar.exists?
         attendee.avatar.url
       else
         attendee.photo.url(:square)
       end
    item['img_url'] = img

    response = {
      attendee: item,
      lottery_prize: lottery_prize,
      event_lottery_prize_item: event_lottery_prize_item
    }

    render status: 'success', json: response
  end

  def lottery_prize_setting

  end

  def set_current_module
    @current_module = 4
  end

  private :set_current_module

end
