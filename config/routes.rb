Rails.application.routes.draw do

  get 'sign_in'       => 'sessions#new',      as: :sign_in
  post 'sign_in'      => 'sessions#create'
  delete 'logout'     => 'sessions#destroy',  as: :sign_out

  get 'set_current_event' => 'events#set_current_event'
  post 'set_current_event' => 'events#update_current_event'
  get 'get_current_event' => 'events#get_current_event'

  root 'home#index'

  resources :access_monitors

  namespace :seller do
    resources :events do
      resources :sessions do
        resources :checkins
      end
    end

    resources :events do
      resources :activities
    end
  end

  namespace :client do
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
      resources :sessions
      resources :event_questions do
        resources :questions
        post 'praises'     => 'questions#praises'
      end
    end
  end

  get 'templates'  => 'templates#show'

  scope 'app' do
    get '/'           => redirect('/app/dashboard')
    get 'dashboard'   =>  'dashboard#index'
    get 'edit_company' => 'companies#edit'
    resources :companies

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

      resources :seats
      get 'set_seat'  => 'seats#set_seat'
      resources :activity_categories
      resources :activities
      resources :sellers
      resources :recommends
      resources :event_session_locations
      resources :attentee_rfids
      resources :checkin_monitors
      resources :restaurants
      resources :attendee_seats
      resources :system_infos
      resources :session_seats
      resources :event_questions do
        resources :questions
      end

      get 'set_current_event_questions' => 'event_questions#set_current_event_questions'
      post 'update_current_event_questions' => 'event_questions#update_current_event_questions'
      resources :event_lottery_prizes do
        get 'lottery_prize_rule' => 'event_lottery_prizes#lottery_prize_rule'
        patch 'update_lottery_prize_rule' => 'event_lottery_prizes#update_lottery_prize_rule'
        get 'start_lottery_prize' => 'event_lottery_prizes#start_lottery_prize'
        get 'get_attendee_list' => 'event_lottery_prizes#get_attendee_list'
        resources :event_lottery_prize_items do
          get 'specify_attendee_lottery' => 'event_lottery_prize_items#specify_attendee_lottery'
          post 'add_specify_attendee_lottery' => 'event_lottery_prize_items#add_specify_attendee_lottery'
          delete 'remove_specify_attendee_lottery' => 'event_lottery_prize_items#remove_specify_attendee_lottery'
        end
        resources :lottery_prizes
      end

      get 'choose_event_question' => 'questions#choose_event_question'
      post 'update_event_function_order' => 'events#update_event_function_order'
      get 'event_base_setting' => 'events#event_base_setting'
      patch 'update_event_base_setting' => 'events#update_event_base_setting'
      get 'welcome_page_setting' => 'events#welcome_page_setting'
      get 'welcome_page_drage_setting' => 'events#welcome_page_drage_setting'
      patch 'update_welcome_page_setting' => "events#update_welcome_page_setting"
      get 'function_setting' => 'events#function_setting'
      patch 'update_function_setting' => 'events#update_function_setting'
      get 'content_setting' => 'events#content_setting'

      get 'live_lottery_prize' => 'lottery_prizes#live_lottery_prize'

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

      #???????????????
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
