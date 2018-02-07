class AttendeesController < ApplicationController
  require 'spreadsheet'
  http_basic_authenticate_with name: Rails.configuration.authen_name, password: Rails.configuration.password
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

    if Seller.phone_number_is(params[:attendee][:mobile]).present?
      flash.now[:error] = '该手机号已作为销售手机号码'
      render :new
      return
    end

    @attendee.province       = params[:province]
    @attendee.city           = params[:city]
    @attendee.owner_attendee = owner_attendee
    @attendee.seller   = seller

    self.generate_photo
    self.generate_avatar

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

    success_count = 0
    error_count = 0
    error_message = ''
    
    invitation_short_url = generate_short_url("#{ENV['HOSTNAME']}/client/events/#{current_event.id}/invites")

    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet.open file_path
    sheet1 = book.worksheet 0
    sheet1.each 1 do |row|
      gender_id = 0 if row[2]=='男'
      gender_id = 1 if row[2]=='女'

      if row[4].present?
        seller = Seller.phone_and_event_is(row[4], current_event).first
      end

      if row[5].present?
        category = AttendeeCategory.category_name_is(current_event, row[5]).first
      end

      @attendee   = current_event.attendees.new name: row[1],
        gender_id: gender_id,
        category: category,
        seller: seller
        company: row[7],
        mobile: row[8].to_i,
        province: row[10],
        city: row[11],
        invitation_short_url: invitation_short_url
      self.generate_photo
      self.generate_avatar

      if @attendee.valid?&&@attendee.save
        success_count += 1
      else
        if '名字'!=row[1]
          error_message = "#{error_message}<br >#{error_count} #{row[1]} #{@attendee.errors.messages}"
          error_count += 1
        end
      end
    end

    if error_count>0
      path = "public/errors"
      FileUtils.mkdir_p(path) unless File.exists?(path)
      current_time = Time.now.to_i
      File.open(path+"/#{current_time}.html","a+") do |file|
        file.set_encoding('utf-8')
        file.puts "<!DOCTYPE HTML><html><head><meta charset='UTF-8'><title>错误日志</title></head><body>"
        file.puts "#{error_message}"
        file.puts "</body></html>"
      end
      redirect_to event_attendees_path(path: "/errors/#{current_time}.html"), flash: {success: "成功导入#{success_count}条, 有#{error_count}条导入失败."}
    else
      redirect_to event_attendees_path, flash: {success: "成功导入#{success_count}条"}
    end

  end

  def edit
    @attendee = current_event.attendees.find(params[:id])
    @seller_name = @attendee.seller.try(:name)
  end

  def update
    @attendee = current_event.attendees.find(params[:id])

    original_mobile = @attendee.mobile

    if @attendee.update(attendee_params)
      if params[:seller_name].present?
        seller = Seller.seller_name_is(params[:seller_name]).first
        if seller.blank?
          flash.now[:error] = '没有找到对应的销售'
          render :edit
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

      if Seller.phone_number_is(params[:attendee][:mobile]).present?
        flash.now[:error] = '该手机号已作为销售手机号码'
        render :edit
        return
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
      if original_mobile!=@attendee.mobile
        if File::exists?("#{Rails.root}/public/system/events/medium/#{original_mobile}.jpg")
          File.rename("#{Rails.root}/public/system/events/medium/#{original_mobile}.jpg", "#{Rails.root}/public/system/events/medium/#{@attendee.mobile}.jpg")
        end
        if File::exists?("#{Rails.root}/public/system/events/square/#{original_mobile}.jpg")
          File.rename("#{Rails.root}/public/system/events/square/#{original_mobile}.jpg", "#{Rails.root}/public/system/events/square/#{@attendee.mobile}.jpg")
        end
        if File::exists?("#{Rails.root}/public/system/events/thumb/#{original_mobile}.jpg")
          File.rename("#{Rails.root}/public/system/events/thumb/#{original_mobile}.jpg", "#{Rails.root}/public/system/events/thumb/#{@attendee.mobile}.jpg")
        end
        if File::exists?("#{Rails.root}/public/system/events/large/#{original_mobile}.jpg")
          File.rename("#{Rails.root}/public/system/events/large/#{original_mobile}.jpg", "#{Rails.root}/public/system/events/large/#{@attendee.mobile}.jpg")
        end
        if File::exists?("#{Rails.root}/public/system/events/original/#{original_mobile}.jpg")
          File.rename("#{Rails.root}/public/system/events/original/#{original_mobile}.jpg", "#{Rails.root}/public/system/events/original/#{@attendee.mobile}.jpg")
        end
        if File::exists?("#{Rails.root}/public/system/events/avatar/#{original_mobile}.jpg")
          File.rename("#{Rails.root}/public/system/events/avatar/#{original_mobile}.jpg", "#{Rails.root}/public/system/events/avatar/#{@attendee.mobile}.jpg")
        end
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
      #如果文件存在则删除该文件
      File.delete("#{Rails.root}/public/upload/#{@filename}") if File::exists?("#{Rails.root}/public/upload/#{@filename}")
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
    @attendee.update event_id: nil
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

  def generate_short_url(long_url)
    Rails.logger.info("[DWZ] Generate Short URL: #{long_url}")
    ret = Timeout::timeout(5) do
      # http = Net::HTTP.post_form(URI.parse('http://dwz.cn/create.php'),{url: long_url})
      Net::HTTP.get(URI.parse("http://api.weibo.com/2/short_url/shorten.json?source=1681459862&url_long=#{long_url}"))
    end
    json = JSON.parse(ret)
    if json['urls']
      json['urls'][0]['url_short']
    elsif json['error']
      'app/model/attendee/150'
      #raise json['error']
    else
      raise json['err_msg']
    end
  end

  def generate_photo
    if @attendee.photo.blank?&&@attendee.mobile.present?
      attendee = Attendee.has_photo.mobile_is(@attendee.mobile).first
      if attendee.present?
        @attendee.photo_file_name = attendee.photo_file_name
        @attendee.photo_content_type = attendee.photo_content_type
        @attendee.photo_file_size = attendee.photo_file_size
      end
    end
  end

  def generate_avatar
    if @attendee.avatar.blank?&&@attendee.mobile.present?
      attendee = Attendee.has_avatar.mobile_is(@attendee.mobile).first
      if attendee.present?
        @attendee.avatar_file_name = attendee.avatar_file_name
        @attendee.avatar_content_type = attendee.avatar_content_type
        @attendee.avatar_file_size = attendee.avatar_file_size
      end
    end
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
