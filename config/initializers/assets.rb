# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css.scss, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  attendee_seats/body_bg.png
  attendee_seats/graphic.jpg
  client/event_sessions/schedule.png
  client/event_sessions/schedule_icon.png
  client/invites/arrow.png
  client/invites/home_page0.png
  client/invites/home_page1.png
  client/invites/title.png
  client/recommends/map_bg.png
  client/recommends/recommends.png
  client/recommends/recommends_icon.png
  client/restaurants/adress.png
  client/restaurants/phone_icon.png
  client/restaurants/restaurants.png
  client/restaurants/restaurants_icon.png
  client/sessions/sessions.png
  client/shared/close.png
  client/shared/metting_logo.png
  client/sites/arrow.png
  client/sites/hotel.png
  client/sites/loading.gif
  client/sites/no_portrait.png
  client/sites/notice.png
  client/sites/official_website.png
  client/sites/periphery.png
  client/sites/schedule.png
  client/sites/seat.png
  client/sites/seat_number.png
  client/sites/sites_illus.png
  client/sites/voucher.png
  
  client_event_sessions_show.js
  client_invites_show.js
  client_restaurants_show.js
  client_sessions_new.js
  client_sites_show.js
  invitations.js 
  province_city.js
  jquery-accordion-menu.js
  seat_new.js
  seat_show.js
  seller_checkins_show.js
  seat_index_display_by_attendee.js
  set_seat.js

  client_event_sessions_show.css
  client_invites_show.css
  client_profiles_show.css
  client_recommends_index.css
  client_restaurants_show.css
  client_sessions_new.css
  client_sites_show.css
  invitations.css
  jquery-accordion-menu.css
  seller_checkins_show.css
)
