module APIv1
  module Helpers

    def authenticate!
      current_admin or error!(code: 401, error: 'Authorization failed.')
    end

    def current_admin
      @current_admin ||= Admin.find_by_auth_token(auth_token) if auth_token
    end

    def auth_token
      @auth_token ||= request.headers['Auth-Token'] || params[:auth_token]
    end
  end
end