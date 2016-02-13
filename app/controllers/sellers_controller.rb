class SellersController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module
  skip_before_action :verify_authenticity_token
  layout 'event'

  def index
    @sellers = current_event.sellers
  end

  def create
    if params[:seller_file].present?
      filename = uploadfile(params[:seller_file])
      file_path = "#{Rails.root}/public/upload/#{@filename}"
      #begin
      SellerList.import(file_path)
      count = 0
      error_collection = []
      SellerList.all.each do |seller|
        manage_name = seller.attributes['manager_name']
        name =  seller.attributes['name']
        if seller.attributes['phone_number'].length>11
          phone_number =seller.attributes['phone_number'].split('.')[0]
        else
          phone_number =seller.attributes['phone_number']
        end
        responsible_area = seller.attributes['responsible_area']

        manager = nil
        managers = Seller.seller_name_is(manage_name) if manage_name.present?
        manager = managers.first if managers.present?
        seller_item = Seller.new name: name,
          phone_number: phone_number,
          responsible_area: responsible_area,
          manager: manager,
          event: current_event
        if seller_item.save
          count+=1
        else
          error_collection << name
        end
      end
      SellerList.all.clear
      # rescue Importex::ImportError => e
      #   puts e.message
      # end
      redirect_to event_sellers_path, flash: {success: "成功导入#{count}"} if error_collection.size==0
      redirect_to event_sellers_path, flash: {error: "成功导入#{count}条, #{error_collection}导入失败"} if error_collection.size>0
    return
    end

    @seller = current_event.sellers.new(seller_params)

    if Attendee.mobile_is(params[:seller][:phone_number]).present?
      flash.now[:error] = '该手机号已作为嘉宾手机号'
      render :new
      return
    end

    if params[:seller_manager_name].present?
      @seller_manager = Seller.seller_name_is(params[:seller_manager_name]).first
      if @seller_manager.blank?
        @seller_manager_name = params[:seller_manager_name]
        flash.now[:error] = '没有找到对应的对接人, 请重新输入'
        render :new
        return
      else
        @seller.manager = @seller_manager
      end
    end

    if @seller.save
      redirect_to event_sellers_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @seller.errors.full_messages
      render :new
    end
  end

  def destroy
    @seller = current_event.sellers.find(params[:id])
    @seller.destroy

    redirect_to event_sellers_path
  end

  def update
    @seller = current_event.sellers.find(params[:id])

    if Attendee.mobile_is(params[:seller][:phone_number]).present?
      logger.info "------line 94"
      flash.now[:error] = '该手机号已作为嘉宾手机号'
      render :edit
      return
    end

    if @seller.update(seller_params)
      @seller_manager = nil

      if params[:seller_manager_name].present?
        @seller_manager = Seller.seller_name_is(params[:seller_manager_name]).first
        if @seller_manager.blank?
          @seller_manager_name = params[:seller_manager_name]
          flash.now[:error] = '没有找到对应的对接人, 请重新输入'
          render :edit
          return
        end
      end
      @seller.manager = @seller_manager
      @seller.save
      redirect_to event_sellers_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @seller.errors.full_messages
      render :edit
    end
  end

  def edit
    @seller = current_event.sellers.find(params[:id])
    @seller_manager_name = @seller.manager.try(:name)
  end

  def new
    @seller = current_event.sellers.build
  end

  def seller_params
    params.require(:seller).permit(:name, :responsible_area, :phone_number)
  end

  def set_current_module
    @current_module = 5
  end

  ##上传文件
  ##file.original_filename 获取文件名字
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

  private :set_current_module, :seller_params, :uploadfile

end
