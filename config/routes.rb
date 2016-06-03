Rails.application.routes.draw do

  get 'sign_in'       => 'sessions#new',      as: :sign_in
  post 'sign_in'      => 'sessions#create'
  delete 'logout'     => 'sessions#destroy',  as: :sign_out

  root 'home#index'

  get '20160223'  => 'redirects#show'

  namespace :seller do
    resources :sessions
    resources :events do
      resources :checkins
    end
  end

  namespace :client do
    resources :sessions
    resources :events do
      get 'event_info' => 'invites#event_info'
      get 'invites'     => 'invites#show'
      get 'system_infos' => 'sites#system_infos'
      get 'seats'  => 'seats#show'
      get 'sites'   => 'sites#show'
      get 'download_qrcode'  => 'sites#download_qrcode'
      post 'upload_photo' => 'sites#upload_photo'
      resources :profiles
      resources :recommends
      get 'restaurants'     => 'restaurants#show'
      resources :event_sessions
    end
  end

  get 'templates'  => 'templates#show'

  scope 'app' do
    get '/'           => redirect('/app/dashboard')
    get 'dashboard'   =>  'dashboard#index'

    resources :events do
      resources :attendees do
        member do
          put 'checkin'     => 'attendees#check_in'
          delete 'checkin'  => 'attendees#uncheck_in'
          delete 'photo'    => 'attendees#destroy_photo'
          delete 'avatar'   => 'attendees#destroy_avatar'
          get 'download_photo' => 'attendees#download_photo'
          post 'upload_photo'  => 'attendees#upload_photo'
          patch 'upload_avatar' => 'attendees#upload_avatar'
          post 'generate_invitation_short_url' => 'attendees#generate_invitation_short_url'
          get 'badge'       => 'attendees#badge'
          get 'avatar'      => 'attendees#avatar'
        end
      end

      resources :questions
      resources :seats
      resources :activity_categories
      resources :activities
      resources :lottery_prizes
      resources :sellers
      resources :recommends
      resources :event_session_locations
      resources :attentee_rfids
      resources :checkin_monitors
      resources :restaurants
      resources :attendee_seats
      resources :system_infos
      resources :session_seats
      resources :event_lottery_prizes do
        resources :event_lottery_prize_items
      end

      post 'update_event_function_order' => 'events#update_event_function_order'
      get 'event_base_setting' => 'events#event_base_setting'
      patch 'update_event_base_setting' => 'events#update_event_base_setting'
      get 'welcome_page_setting' => 'events#welcome_page_setting'
      patch 'update_welcome_page_setting' => "events#update_welcome_page_setting"
      get 'function_setting' => 'events#function_setting'
      patch 'update_function_setting' => 'events#update_function_setting'
      get 'content_setting' => 'events#content_setting'

      get 'live_lottery_prize' => 'lottery_prizes#live_lottery_prize'
      get 'lottery_prize_setting' => 'lottery_prizes#lottery_prize_setting'
      get 'lottery_prize_rule' => 'lottery_prizes#lottery_prize_rule'

      get 'search_attendees' => 'seats#search_attendee'
      post 'dele_attendee_seat' => 'seats#dele_attendee_seat'
      post 'update_attendee_seat' => 'seats#update_attendee_seat'
      get 'search_by_session_row' => 'seats#search_by_session_row'
      get 'get_session_seat'  => 'seats#get_session_seat'
      get 'get_seats_tablerow' => 'seats#get_seats_tablerow'
      get 'arrange_seat'    => 'seats#arrange_seat'
      get 'photos'          => 'attendees#photos'
      get 'site/search_attendee'     => 'site#search_attendee'

      post 'notifications'   => 'notifications#create'
      get 'notifications'   => 'notifications#index'
      post 'site/binding_rfid'      => 'site#binding_rfid'
      post 'notifications/:attendee_id/send_sms' => 'notifications#send_sms',     as: :notifications_send_sms
      get  'notifications/edit_sms_template' => 'notifications#edit_sms_template'
      patch 'notifications/update_sms_template' => 'notifications#update_sms_template'
      get  'notifications/send_test_sms' => 'notifications#send_test_sms'

      #邀请函设置
      get 'invitation_settings' => 'invitation_settings#index',                            as: :invitation_settings
      patch 'update_invitation_settings' => 'invitation_settings#update',                    as: :update_invitation_settings

      get 'prints' => 'prints#index'

      resources :sessions, controller: 'event_sessions'

      resources :attendee_categories
      get 'dashboard'  => 'events#dashboard'

      get 'settings'            => 'events#settings'
      patch 'save_settings'     => 'events#save_settings'

      get 'checkin/:session_id' => 'checkin#sessions' , as: :session_checkin
      get 'checkin/:session_id/export' => 'checkin#export', as: :session_checkin_export
      get 'checkin/:session_id/company_export' => 'checkin#company_export', as: :session_company_checkin_export
      get 'checkin'            => 'checkin#index'
      put 'checkin/:session_id/check_in/:attendee_id'        => 'checkin#check_in',   as: :session_check_in
      delete 'checkin/:session_id/uncheck_in/:attendee_id'   => 'checkin#uncheck_in', as: :session_uncheck_in

      get 'export' => 'attendees#export'

      get 'site'          => 'site#index'

      get 'site/:session_id/search'      => 'site#search',     as: :site_search

      get 'site/:session_id' => 'site#sessions',     as: :site_session
      # get 'site/:session_id/checkin/:token/:sn'  => 'site#checkin', as: :site_session_checkin
      get 'site/:session_id/attendees'                    => 'site#attendees',  as: :site_attendees
      match 'site/:session_id/check_in'                    => 'site#check_in',  via: [:get, :post],  as: :site_check_in
      match 'site/:session_id/uncheck_in'                    => 'site#uncheck_in',  via: [:post],  as: :site_uncheck_in
      match 'site/:session_id/checkin' => 'site#checkin',  via: [:get, :post],  as: :site_session_checkin

    end

    resources :admins

  end

  scope :invitations do
    get ':attendee_token/confirmation' => 'invitations#confirmation', as: :invitations_confirmation
    get ':attendee_token/sessions'     => 'invitations#sessions',     as: :invitations_sessions
    post ':attendee_token/upload'     => 'invitations#upload',      as: :invitations_upload
    get ':attendee_token/done'         => 'invitations#done',         as: :invitations_done
    get ':attendee_token'              => 'invitations#index',        as: :invitations_info
  end

  mount APIv1::API => '/'

end
