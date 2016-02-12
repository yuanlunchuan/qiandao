module SellerLoader

  extend ActiveSupport::Concern

  self.included do |includer|

    def load_seller
      if cookies[:seller_id].blank?
        redirect_to new_client_session_path
      else
        seller = Seller.find_by(id: cookies[:seller_id])
        if seller.present?
          session[:seller_id] = seller.id
        else
          cookies[:seller_id] = nil
          redirect_to new_client_session_path
        end
      end
    end
  end
end
