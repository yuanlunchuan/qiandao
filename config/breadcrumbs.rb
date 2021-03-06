crumb :root do
  link "首页", event_dashboard_path
end

crumb :new_event_question do
  link '新增问题环节', event_set_current_event_questions_path(current_event)
  parent :event_questions
end

crumb :set_current_event_question do
  link '设置当前提问环节', event_set_current_event_questions_path(current_event)
  parent :event_questions
end

crumb :event_question do |event_question|
  link event_question.name, event_event_question_path(current_event, event_question)
  parent :event_questions
end

crumb :edit_event_question do |event_question|
  link '编辑环节列表', edit_event_event_question_path(current_event, event_question)
  parent :event_questions
end

crumb :event_questions do
  link '问题环节列表', event_event_questions_path(current_event)
end

crumb :edit_session_seat do
  link '设置微网站座位查询', new_event_seat_path
end

crumb :display_by_attendee do |cat|
  link '名单查看', event_seats_path
  parent :set_seat
end

crumb :display_by_seat do |cat|
  link '按座位查看', event_seats_path
  parent :set_seat
end

crumb :display_by_attendees_from_attendee do |cat|
  link '名单查看', event_seats_path
  parent :set_attendee_seat
end

crumb :display_by_seat_from_attendee do |cat|
  link '按座位查看', event_seats_path
  parent :set_attendee_seat
end

crumb :set_attendee_seat do |cat|
  link '安排嘉宾座位', new_event_seat_path
  parent :set_seat
end

crumb :set_seat do
  link '座位设置', event_set_seat_path(current_event)
end

crumb :new_seytem_info do |cat|
  link '发布系统消息', event_system_infos_path
  parent :system_infos
end

crumb :edit_system_info do |cat|
  link '编辑系统消息', event_system_infos_path
  parent :system_infos
end

crumb :system_infos do
  link '系统消息管理', event_system_infos_path
end

crumb :edit_restaurant do
  link '酒店信息设置', event_attentee_rfids_path
end

crumb :attendee_rfids do
  link '嘉宾RFID信息录入', event_attentee_rfids_path
end

crumb :locations do
  link '会议场地管理', event_event_session_locations_path
end

crumb :seats do
  link '座位安排', new_event_seat_path
end

crumb :seat_show do
  link '查看座位', new_event_seat_path
end

crumb :recommends do
  link '推荐列表', event_recommends_path
end

crumb :new_recommend do |cat|
  link '新增推荐', new_event_recommend_path
  parent :recommends
end

crumb :edit_recommend do |cat|
  link '编辑推荐', event_recommends_path
  parent :recommends
end

crumb :sellers do
  link '销售管理', event_sellers_path
end

crumb :new_sellers do |cat|
  link '新增销售', new_event_seller_path
  parent :sellers
end

crumb :edit_seller do |cat|
  link '编辑销售', event_sellers_path
  parent :sellers
end

crumb :specify_lottery_prize_attendee do |event_lottery_prize, event_lottery_prize_item|
  link '指定中奖人管理', event_event_lottery_prize_event_lottery_prize_item_specify_attendee_lottery_path(current_event, event_lottery_prize, event_lottery_prize_item)
  parent :event_lottery_prize, event_lottery_prize
end

crumb :lottery_prize_rule do |event_lottery_prize|
  link '抽奖规则设置', event_event_lottery_prize_lottery_prize_rule_path(current_event, event_lottery_prize.id)
  parent :event_lottery_prize, event_lottery_prize
end

crumb :edit_event_lottery_prize_item do |event_lottery_prize|
  link '编辑奖项', new_event_event_lottery_prize_path(current_event)
  parent :event_lottery_prize, event_lottery_prize
end

crumb :add_event_lottery_prizes do |event_lottery_prize|
  link '新增奖项', new_event_event_lottery_prize_path(current_event)
  parent :event_lottery_prize, event_lottery_prize
end

crumb :edit_event_lottery_prize do |event_lottery_prize|
  link '编辑抽奖活动', edit_event_event_lottery_prize_path(current_event, event_lottery_prize.id)
  parent :event_lottery_prizes
end

crumb :new_event_lottery_prize do
  link '新增抽奖活动', new_event_event_lottery_prize_path(current_event)
  parent :event_lottery_prizes
end

crumb :event_lottery_prize do |event_lottery_prize|
  link event_lottery_prize.name, event_event_lottery_prize_path(current_event, event_lottery_prize.id)
  parent :event_lottery_prizes
end

crumb :event_lottery_prizes do
  link '抽奖活动列表', event_event_lottery_prizes_path(current_event)
end

crumb :lottery_prizes do
  link '中奖列表', event_questions_path
end

crumb :questions do
  link '提问审核', event_questions_path
end

crumb :seats_new do
  link '现场签到管理', event_questions_path
end

crumb :activities do
  link '活动管理', event_activities_path
end

crumb :new_activity do |cat|
  link '添加活动', new_event_activity_path
  parent :activities
end

crumb :edit_activity do |cat|
  link '编辑活动', new_event_activity_path
  parent :activities
end

crumb :activity_categories do
  link '活动标签管理', event_activity_categories_path
end

crumb :edit_activity_category do |cat|
  link '编辑活动标签', event_activity_category_path
  parent :activity_categories
end

crumb :new_activity_category do |cat|
  link '添加标签', new_event_activity_category_path
  parent :activity_categories
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
