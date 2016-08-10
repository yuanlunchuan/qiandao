class AccessMonitorsController < ApplicationController
  layout 'empty'

  def index
    if params[:key] != '13551031965'
      redirect_to sign_in_path(back_url: request.original_url)
    end

    @access_records = AccessRecord.all
    @access_records = AccessRecord.white_list if 'white_list' == params[:filter]
    @access_records = AccessRecord.black_list if 'black_list' == params[:filter]

    @total = AccessRecord.all.size
    @white_list_total = AccessRecord.white_list.size
    @black_list_total = AccessRecord.black_list.size
  end

  def show
    access_record = AccessRecord.find(params[:id])
    access_record.update is_trust: !access_record.is_trust, is_notification: true
    redirect_to access_monitors_path(key: '13551031965', filter: params[:filter])
  end
end
