crumb :root do
  link "首页", event_dashboard_path
end

crumb :attendees do
  link '全部报名用户', event_attendees_path
end

crumb :attendee do |attendee|
  link attendee.name, event_attendee_path
  parent :attendees
end

crumb :edit_attendee do |attendee|
  link '编辑报名用户', event_attendee_path
  parent :attendees
end

crumb :attendee_avatar do |attendee|
  link '编辑头像', avatar_event_attendee_path
  parent :attendee, attendee
end

crumb :new_attendee do
  link '添加报名用户', new_event_attendee_path
  parent :attendees
end

crumb :attendee_categories do
  link '用户标签', event_attendee_categories_path
end

crumb :attendee_category do |cat|
  link cat.name, event_attendee_category_path
  parent :attendee_categories
end

crumb :edit_attendee_category do |cat|
  link '编辑用户标签', event_attendee_category_path
  parent :attendee_categories
end

crumb :new_attendee_category do
  link '添加标签', new_event_attendee_path
  parent :attendee_categories
end

crumb :checkin do
  link '用户签到管理', event_checkin_path
end

crumb :checkin_session do |event, session|
  link session.name, event_session_checkin_path(event, session)
  parent :checkin
end

crumb :sessions do
  link '会议日程管理', event_sessions_path
end

crumb :new_session do
  link '新增会议日程', new_event_session_path
  parent :sessions
end

crumb :edit_session do |session|
  link '修改会议日程', event_sessions_path
  parent :sessions
end

crumb :notifications do
  link '会议通知管理',  event_notifications_path
end

crumb :prints do
  link '入场证打印', event_prints_path
end

crumb :notifications do
  link '会议通知管理', event_notifications_path
end

crumb :notifications_edit_sms_template do
  link '编辑短信模板', event_notifications_edit_sms_template_path
  parent :notifications
end

crumb :notifications_send_test_sms do
  link '发送测试短信', event_notifications_send_test_sms_path
  parent :notifications
end

crumb :invitation_settings do
  link '邀请函设置', event_invitation_settings_path
end

crumb :photos do
  link '用户照片管理', event_photos_path
end


# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).