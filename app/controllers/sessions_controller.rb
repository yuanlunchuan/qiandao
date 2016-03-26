require "fileutils"

class SessionsController < ApplicationController
  layout 'empty'

  def new
    Attendee.all.each do |attendee|
      if attendee.photo.present?
        FileUtils.cp "#{Rails.root}/public/system/events/#{attendee.event.id}/attendees/large/#{attendee.attendee_number}-#{attendee.token}.jpg", "#{Rails.root}/public/system/events/large/#{attendee.mobile}.jpg"
        FileUtils.cp "#{Rails.root}/public/system/events/#{attendee.event.id}/attendees/medium/#{attendee.attendee_number}-#{attendee.token}.jpg", "#{Rails.root}/public/system/events/medium/#{attendee.mobile}.jpg"
        FileUtils.cp "#{Rails.root}/public/system/events/#{attendee.event.id}/attendees/original/#{attendee.attendee_number}-#{attendee.token}.jpg", "#{Rails.root}/public/system/events/original/#{attendee.mobile}.jpg"
        FileUtils.cp "#{Rails.root}/public/system/events/#{attendee.event.id}/attendees/square/#{attendee.attendee_number}-#{attendee.token}.jpg", "#{Rails.root}/public/system/events/square/#{attendee.mobile}.jpg"
        FileUtils.cp "#{Rails.root}/public/system/events/#{attendee.event.id}/attendees/thumb/#{attendee.attendee_number}-#{attendee.token}.jpg", "#{Rails.root}/public/system/events/thumb/#{attendee.mobile}.jpg"
        FileUtils.cp "#{Rails.root}/public/system/events/#{attendee.event.id}/attendees/avatar/#{attendee.attendee_number}-#{attendee.token}.jpg", "#{Rails.root}/public/system/events/avatar/#{attendee.mobile}.jpg"
      end
    end

  end

  def create
    admin = Admin.find_by_name(params[:name])

    if admin && admin.password_digest==params[:password]
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
