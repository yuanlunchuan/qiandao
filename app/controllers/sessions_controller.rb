require "fileutils"

class SessionsController < ApplicationController
  layout 'empty'

  def new

  end

  def create
    admin = Admin.find_by(phone_number: params[:phone_number])
    if admin && admin.password_digest==params[:password]
      unless admin.company
        logger.info "公司信息不存在"
        flash.now.alert = '公司信息不存在'
        render 'new'
      end

      if params[:remember_me]
        cookies.permanent[:auth_token] = admin.auth_token
      else
        cookies[:auth_token] = admin.auth_token
      end
      cookies[:company_id] = admin.company.id

      back_url = params[:back_url].present? ? params[:back_url] : dashboard_path
      redirect_to back_url

    else
      flash.now.alert = '用户名或密码不正确'
      render 'new'
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to dashboard_path
  end
end
