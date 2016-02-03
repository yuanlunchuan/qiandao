# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css.scss, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  client/sessions/sessions.png
  client/sites/arrow.png
  client/sites/home_page0.png
  client/sites/home_page1.png
  client/sites/metting_logo.png

  client_sessions_new.js
  client_sites_show.js
  invitations.js 
  province_city.js
  seats.js
  jquery.seat-charts.min.js
  jquery-accordion-menu.js

  client_profiles_show.css
  client_sessions_new.css
  client_sites_show.css
  seats.css
  invitations.css
  jquery-accordion-menu.css
)
