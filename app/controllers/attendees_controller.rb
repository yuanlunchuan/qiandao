class AttendeesController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module
  skip_before_action :verify_authenticity_token
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
    if params[:attendee_file].present?
      import_attendee
      return
    end

    @attendee          = current_event.attendees.new attendee_params

    if params[:owner_attendee_name].present?
      owner_attendee = Attendee.attendee_name_is(params[:owner_attendee_name]).first
      if owner_attendee.blank?
        flash.now[:error] = '没有找到主嘉宾'
        render :new
        return
      end
    end

    if params[:seller_name].present?
      seller             = Seller.seller_name_is(params[:seller_name]).first
      if seller.blank?
        flash.now[:error] = '没有找到对应的销售'
        render :new
        return
      end
    end

    @attendee.province       = params[:province]
    @attendee.city           = params[:city]
    @attendee.owner_attendee = owner_attendee
    @attendee.seller   = seller

    if @attendee.save
      redirect_to event_attendees_path, flash: {success: '添加成功'}
    else
      flash.now[:error] = @attendee.errors.full_messages
      render :new
    end
  end

  def import_attendee
    filename = uploadfile(params[:attendee_file])
    file_path = "#{Rails.root}/public/upload/#{@filename}"

    AttendeeList.import(file_path)
    count = 0
    error_count = 0
    AttendeeList.all.each do |attendee|
      gender_id = 0 if attendee.attributes['gender']=='男'
      gender_id = 1 if attendee.attributes['gender']=='女'

      category_name = attendee.attributes['category_name']
      category = AttendeeCategory.category_name_is(category_name).first if category_name.present?

      if attendee.attributes['mobile'].length>11
        mobile =attendee.attributes['mobile'].split('.')[0]
      else
        mobile =attendee.attributes['mobile']
      end

      attendee.attributes.delete('category_name')
      attendee.attributes.delete('gender')
      attendee_item           = Attendee.new attendee.attributes
      attendee_item.category  = category
      attendee_item.gender_id = gender_id
      attendee_item.mobile    = mobile
      attendee_item.event     =current_event

      if attendee_item.save
        count += 1
      else
        error_count += 1
      end
    end
    AttendeeList.all.clear
    redirect_to event_attendees_path, flash: {success: "成功导入#{count}"} if error_count==0
    redirect_to event_attendees_path, flash: {error: "成功导入#{count}条, 有#{error_count}条导入失败"} if error_count>0
  return
  end

  def edit
    @attendee = current_event.attendees.find(params[:id])
    @seller_name = @attendee.seller.try(:name)
  end

  def update
    @attendee = current_event.attendees.find(params[:id])

    if @attendee.update(attendee_params)
      if params[:seller_name].present?
        seller = Seller.seller_name_is(params[:seller_name]).first
        if seller.blank?
          flash.now[:error] = '没有找到对应的销售'
          render :new
          return
        end
      end

      if params[:owner_attendee_name].present?
        owner_attendee = Attendee.attendee_name_is(params[:owner_attendee_name]).first
        if owner_attendee.blank?
          flash.now[:error] = '没有找到主嘉宾'
          render :edit
          return
        end
      end

      @attendee.province = params[:province]
      @attendee.city     = params[:city]
      @attendee.seller = seller
      @attendee.owner_attendee = owner_attendee

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

  ##上传文件
  def uploadfile(file)
    if !file.original_filename.empty?
      @filename = file.original_filename
      #设置目录路径，如果目录不存在，生成新目录
      FileUtils.mkdir("#{Rails.root}/public/upload") unless File.exist?("#{Rails.root}/public/upload")
      #写入文件
      ##wb 表示通过二进制方式写，可以保证文件不损坏
      File.open("#{Rails.root}/public/upload/#{@filename}", "wb") do |f|
        f.write(file.read)
      end
      return @filename
    end
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

  def set_current_module
    @current_module = 2
  end

  def attendee_params
    params.require(:attendee).permit(:name, :company, :email, :mobile, :category_id, :photo, :gender_id, :province, :city, :avatar, :rfid_num, :level)
  end

end
