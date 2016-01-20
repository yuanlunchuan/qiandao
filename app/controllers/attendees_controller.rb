class AttendeesController < ApplicationController
  before_action :authorize_admin!
  layout 'event'

  def export
    @attendees = current_event.attendees.includes(:category)
    render xlsx: 'export', filename: "attendees-#{Time.now.to_s(:url)}.xlsx"
  end

  def avatar
    @attendee = current_event.attendees.find(params[:id])
  end

  def index
    params[:has_photo]  ||= '0'
    params[:has_avatar] ||= '0'
    @attendees = current_event.attendees
    @attendees = @attendees.category(params[:category_id]) if params[:category_id].present?
    @attendees = @attendees.has_photo if params[:has_photo] == '1'
    @attendees = @attendees.has_avatar if params[:has_avatar] == '1'
    @attendees = @attendees.does_not_have_photo  if params[:has_photo] == '-1'
    @attendees = @attendees.does_not_have_avatar if params[:has_avatar] == '-1'
    @attendees = @attendees.does_not_processed_avatar if params[:has_avatar] == '-2'
    @attendees = @attendees.contains(params[:keyword]) if params[:keyword].present?
    @attendees = @attendees.page(params[:page]).includes(:category)
  end

  def photos
    index
  end

  def new
    @attendee = current_event.attendees.build
  end

  def create
    @attendee          = current_event.attendees.new attendee_params
    @attendee.province = params[:province]
    @attendee.city     = params[:city]

    if @attendee.save
      redirect_to event_attendees_path, flash: {success: '添加成功'}
    else
      flash.now[:error] = @attendee.errors.full_messages
      render :new
    end
  end

  def edit
    @attendee = current_event.attendees.find(params[:id])
  end

  def update
    @attendee = current_event.attendees.find(params[:id])

    if @attendee.update(attendee_params)
      @attendee.province = params[:province]
      @attendee.city     = params[:city]
      @attendee.save
      if(params[:_delete_photo] == '1')
        @attendee.photo.clear
        @attendee.save
      end
      redirect_to event_attendee_path(current_event, @attendee), flash: {success: '编辑成功'}
    else
      flash.now[:error] = @attendee.errors.full_messages
      render :edit
    end
  end

  def upload_avatar
    @attendee = current_event.attendees.find(params[:id])
    if @attendee.update(attendee_params)
      back_url = params[:back_url].present? ? params[:back_url] : event_attendee_path(current_event, @attendee)
      redirect_to back_url, flash: {success: '头像更新成功'}
    else
      flash.now[:error] = @attendee.errors.full_messages
      render :avatar
    end
  end

  def show
    @attendee = current_event.attendees.find(params[:id])
    @qr = RQRCode::QRCode.new(@attendee.qrcode, size: 5, level: :h)
  end

  def destroy
    @attendee = current_event.attendees.find(params[:id])
    @attendee.destroy
    redirect_to event_attendees_path, flash: {success: '删除成功'}
  end

  def check_in
    @attendee = current_event.attendees.find(params[:id])
    @attendee.checked_in_at = Time.now
    @attendee.save
    redirect_to :back
  end

  def uncheck_in
    @attendee = current_event.attendees.find(params[:id])
    @attendee.checked_in_at = nil
    @attendee.save
    redirect_to :back
  end

  def destroy_photo
    @attendee = current_event.attendees.find(params[:id])
    @attendee.photo.clear
    @attendee.save
    redirect_to :back
  end

  def destroy_avatar
    @attendee = current_event.attendees.find(params[:id])
    @attendee.avatar.clear
    @attendee.save
    redirect_to :back
  end

  def upload_photo
    @attendee = current_event.attendees.find(params[:id])
    @attendee.photo = params[:file]
    @attendee.save
    respond_to do |format|
      format.json {render json: {code: 0, message: 'ok'}}
    end
  end

  def download_photo
    @attendee = current_event.attendees.find(params[:id])
    return redirect_to :back unless @attendee.photo.exists?
    send_file @attendee.photo.path, filename: "#{@attendee.attendee_number}-#{@attendee.name}.jpg", type: 'image/jpeg', disposition: 'attachment'
  end

  def generate_invitation_short_url
     @attendee = current_event.attendees.find(params[:id])
     begin
       url = @attendee.generate_invitation_short_url
       redirect_to :back, flash: {success: '生成成功'}
     rescue => e
       redirect_to :back, flash: {error: e.message}
     end
  end

  def badge
    @attendee = current_event.attendees.find(params[:id])
    @attendee.update(printed_at: Time.now) if params[:print].present?
    respond_to do |format|
      format.pdf do
        pdf = BadgePdf.new(@attendee, background: params[:preview].present?)
        send_data pdf.render, filename: "badge-#{@attendee.attendee_number}.pdf",
                                  type: "application/pdf",
                                  disposition: 'inline'
      end
    end
  end

private

  def attendee_params
    params.require(:attendee).permit(:name, :company, :email, :mobile, :category_id, :photo, :gender_id, :province, :city, :avatar, :rfid_num)
  end

end
