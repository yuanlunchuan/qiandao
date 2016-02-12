module SellerLoader

  extend ActiveSupport::Concern

  self.included do |includer|

    def load_seller
      if cookies[:seller_id].blank?
        cookies[:seller_id] = nil
        redirect_to new_seller_session_path
      else
        seller = Seller.find_by(id: cookies[:seller_id])
        if seller.present?
          if current_event.id==seller.event.id
            session[:seller_id] = seller.id
          else
            cookies[:seller_id] = nil
            redirect_to new_seller_session_path
          end
        else
          cookies[:seller_id] = nil
          redirect_to new_seller_session_path
        end
      end
    end
  end
end
