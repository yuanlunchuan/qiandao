module SellerLoader

  extend ActiveSupport::Concern

  self.included do |includer|

    def load_seller
      if cookies[:seller_id].blank?
        cookies[:seller_id] = nil
        redirect_to new_seller_event_session_path current_event.id
      else
        seller = Seller.find_by(id: cookies[:seller_id])
        if seller.present?
          if current_event.id==seller.event.id
            session[:seller_id] = seller.id
          else
            cookies[:seller_id] = nil
            redirect_to new_seller_event_session_path current_event.id
          end
        else
          cookies[:seller_id] = nil
          redirect_to new_seller_event_session_path current_event.id
        end
      end
    end
  end
end
