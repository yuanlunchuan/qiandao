class LotteryPrizesController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module

  layout 'event'
  def index
    
  end

  def new
    
  end

  def set_current_module
    @current_module = 4
  end

  private :set_current_module

end
