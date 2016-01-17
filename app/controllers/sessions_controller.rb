class SessionsController < ApplicationController
  layout 'empty'

  def new
  end

  def create
    admin = Admin.find_by_name(params[:name])

    if true||admin && admin.authenticate(params[:password])

      if params[:remember_me]
        cookies.permanent[:auth_token] = admin.auth_token
      else
        cookies[:auth_token] = admin.auth_token
      end

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
