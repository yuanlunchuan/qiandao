class AdminsController < ApplicationController
  before_action :authorize_admin!

  def index
    @admins = Admin.all
  end

  def update
    @admin = Admin.find(params[:id])
    return redirect_to admins_path if @admin.root?

    params[:admin].delete(:password) if params[:admin][:password].blank?

    if @admin.update(admin_param)
      redirect_to admins_path, flash:{success: '编辑成功'}
    else
      flash.now[:error] = @admin.errors.full_messages.join("<br>")
      render :edit
    end
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_param)
    if @admin.save
      redirect_to admins_path, flash:{success: '添加成功'}
    else
      flash.now[:error] = @admin.errors.full_messages.join("<br>")
      render :edit
    end
  end

  def edit
    @admin = Admin.find(params[:id])
    return redirect_to admins_path if @admin.root?
  end

  def destroy
    @admin = Admin.find(params[:id])
    return redirect_to admins_path if @admin.root?
    @admin.destroy
    redirect_to admins_path, flash:{success: '删除成功'}
  end

private
  def admin_param
    params.require(:admin).permit(:name, :password, :memo)
  end
end
