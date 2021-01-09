class SellersController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module
  skip_before_action :verify_authenticity_token
  layout 'event'

  def index
    @sellers = Seller.all
    @sellers = @sellers.page(params[:page])

  end

  def create
    if params[:seller_file].present?
      filename = uploadfile(params[:seller_file])
      file_path = "#{Rails.root}/public/upload/#{@filename}"

      Spreadsheet.client_encoding = 'UTF-8'
      book = Spreadsheet.open file_path
      sheet1 = book.worksheet 0
      count = 0
      error_collection = []
      sheet1.each 1 do |row|
        seller_item = Seller.new name: row[0],
          phone_number: row[2].to_i.to_s,
          responsible_area: row[1],
          event: current_event

        if Seller.phone_number_is(row[2].to_i.to_s).blank?&&seller_item.save
          count+=1
        else
          error_collection << row[0]
        end
      end

      redirect_to event_sellers_path, flash: {success: "成功导入#{count}"} if error_collection.size==0
      redirect_to event_sellers_path, flash: {error: "成功导入#{count}条, #{error_collection}导入失败"} if error_collection.size>0
      return
    end

    @seller = current_event.sellers.new seller_params 

    if params[:seller_manager_name].present?
      @seller_manager = Seller.seller_name_is(params[:seller_manager_name]).first
      if @seller_manager.blank?
        @seller_manager_name = params[:seller_manager_name]
        flash.now[:error] = '没有找到对应的对接人请重新输入'
        render :new
        return
      else
        @seller.manager = @seller_manager
      end
    end

    if Seller.phone_number_is(@seller.phone_number).blank?&&@seller.save
      redirect_to event_sellers_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = '手机号已经存在'
      render :new
    end
  end

  def destroy
    @seller = Seller.find_by(id: params[:id])
    @seller.destroy

    redirect_to event_sellers_path
  end

  def update
    @seller = Seller.find_by(id: params[:id])

    if Seller.phone_number_is(params[:seller][:phone_number]).blank?&&@seller.update(seller_params)
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
      flash.now[:error] = '手机号已经存在'
      render :edit
    end
  end

  def edit
    @seller = Seller.find_by(id: params[:id])
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

  private :set_current_module, :seller_params, :uploadfile

end
