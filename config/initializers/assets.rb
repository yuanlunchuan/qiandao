# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css.scss, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  client/invites/arrow.png
  client/invites/home_page0.png
  client/invites/home_page1.png
  client/sessions/sessions.png
  client/shared/metting_logo.png
  client/sites/no_portrait.png
  client/sites/notice.png
  client/sites/sites_illus.png
  
  client_invites_show.js
  client_sessions_new.js
  client_sites_show.js
  invitations.js 
  province_city.js
  jquery-accordion-menu.js

  client_invites_show.css
  client_sessions_new.css
  client_sites_show.css
  invitations.css
  jquery-accordion-menu.css
)
