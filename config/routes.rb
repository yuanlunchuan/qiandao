Rails.application.routes.draw do

  get 'sign_in'       => 'sessions#new',      as: :sign_in
  post 'sign_in'      => 'sessions#create'
  delete 'logout'     => 'sessions#destroy',  as: :sign_out

  root 'home#index'

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

      get 'photos'          => 'attendees#photos'

      get 'notifications'   => 'notifications#index'
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
