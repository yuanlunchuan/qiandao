class AddPermissionToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :restaurant_permission, :boolean
    add_column :admins, :session_manage_permission, :boolean
    add_column :admins, :session_notifacation_permission, :boolean
    add_column :admins, :attendee_manage_permission, :boolean
    add_column :admins, :checkin_manage_permission, :boolean
    add_column :admins, :interaction_manage_permission, :boolean
    add_column :admins, :seller_manage_permission, :boolean
    add_column :admins, :event_manage_permission, :boolean
  end
end
