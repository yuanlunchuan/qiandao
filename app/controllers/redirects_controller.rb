class RedirectsController < ApplicationController
  def show
    redirect_to client_invites_path
  end

end