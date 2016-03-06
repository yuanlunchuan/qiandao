class CheckinController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module
  skip_before_action :verify_authenticity_token

  layout 'event'

  def index
  end

  def create
    filename = uploadfile(params[:attendee_file])
    file_path = "#{Rails.root}/public/upload/#{@filename}"

    success_count = 0
    error_count = 0
    error_message = ''
    File.open(file_path) do |file|
      file.each_line{|line|
        phone_number = line.split(',')[3]
        state = line.split(',')[4]
        if '已签到'==state
          attendee = Attendee.mobile_is(phone_number).first
          session = Session.find(params[:session_id])

          checkin = Checkin.new session: session, attendee: attendee
          if checkin.save
            success_count += 1
          else
            error_count += 1
            error_message = "#{error_message}, #{phone_number}"
          end
        end

      #   gender_id = 0 if line.split(',')[2]=='男'
      #   gender_id = 1 if line.split(',')[2]=='女'
      #   if line.split(',')[11].present?
      #     city = line.split(',')[11].split("\n")[0]
      #   end

      #   if line.split(',')[5].present?
      #     category = AttendeeCategory.category_name_is(line.split(',')[5]).first
      #   end

      #   attendee   = current_event.attendees.new name: line.split(',')[1],
      #   gender_id: gender_id,
      #   category: category,
      #   company: line.split(',')[7],
      #   mobile: line.split(',')[8],
      #   province: line.split(',')[10],
      #   city: city

      #   if attendee.save
      #     success_count += 1
      #   else
      #     if '名字'!=line.split(',')[1]
      #       error_message = "#{error_message}, #{line.split(',')[1]}"
      #       error_count += 1
      #     end
      #   end
      # }
      }
    file.close()
    end
    redirect_to event_attendees_path, flash: {success: "成功导入#{success_count}条, 有#{error_count}条导入失败, #{error_message}"}
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

  def export
    @session = current_event.sessions.find(params[:session_id])
    @attendees = current_event.attendees
    render xlsx: 'export', filename: "#{Time.now.to_s(:url)}.xlsx"
  end

  def company_export
    @session = current_event.sessions.find(params[:session_id])
    @attendees1 = @session.attendees.unscope(:order).order('checkins.checked_in_at ASC')
    #@attendees2 = current_event.attendees.where.not(company: @session.attendees.pluck(:company)).group(:company)
    @attendees2 = current_event.attendees.where.not(company: @session.attendees.pluck(:company)).select('attendees.company').group(:company).reorder('attendees.company')
    render xlsx: 'company_export', filename: "#{Time.now.to_s(:url)}.xlsx"
  end

  def sessions
    @session = current_event.sessions.find(params[:session_id])
    return sessions_company if @session.company_checkin?

    params[:checked_in] ||= '0'

    @total = current_event.attendees.count
    @checked_in_numbers = @session.checkins.count

    if params[:checked_in] == '0'
      @attendees = current_event.attendees
    elsif params[:checked_in] == '1'
      @attendees = @session.attendees.unscope(:order).order(checked_in_at: :desc)
    else
      @attendees = current_event.attendees.where.not(id: @session.attendees.pluck(:id))
    end

    @attendees = @attendees.category(params[:category_id]) if params[:category_id].present?
    @attendees = @attendees.contains(params[:keyword]) if params[:keyword].present?
    @attendees = @attendees.page(params[:page]).includes(:category)

  end

  def uncheck_in
    @session = current_event.sessions.find(params[:session_id])
    @attendee = current_event.attendees.find(params[:attendee_id])
    @session.checkins.where(attendee: @attendee).destroy_all
    redirect_to :back, flash: {success: '取消签到成功'}
  end

  def check_in
    @session = current_event.sessions.find(params[:session_id])
    @attendee = current_event.attendees.find(params[:attendee_id])
    @session.checkins.create(attendee: @attendee) unless @session.checkins.where(attendee: @attendee).count > 0
    @attendee.update(checked_in_at: Time.now) if @attendee.checked_in_at.nil?
    redirect_to :back, flash: {success: '签到成功'}
  end

private

  def set_current_module
    @current_module = 3
  end

  def sessions_company
    params[:checked_in] ||= '1'

    @total = current_event.attendees.select(:company).distinct.count
    @checked_in_numbers = @session.checkins.count

    if params[:checked_in] == '0'
      @attendees = current_event.attendees.group(:company)
      @attendees = @attendees.page(params[:page]).per(200).includes(:category)
    elsif params[:checked_in] == '1'
      @attendees = @session.attendees
      @attendees = @attendees.page(params[:page]).per(200).includes(:category)
    else
      #@attendees = current_event.attendees.where.not(company: @session.attendees.pluck(:company)).group(:company)
      @attendees = current_event.attendees.where.not(company: @session.attendees.pluck(:company)).select('attendees.company').group(:company).reorder('attendees.company')
      @attendees = @attendees.page(params[:page]).per(200)#.includes(:category)
    end

    render 'sessions_company'
  end

end
