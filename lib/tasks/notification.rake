namespace :notification do
  desc '发送邀请函短信'
  task :send, [:event_id] => :environment do |t, args|
    next unless args[:event_id]
    event_id = args[:event_id]
    event = Event.find(event_id)
    template = event.sms_template

    raise 'Template not found' unless template or template.content.blank?

    puts '---------- TEMPLATE ---------------'
    puts template.content
    puts '------------------- ---------------'

    sleep 2

    event.attendees.sms_not_sent.each do |attendee|
      begin
        puts "Send To Attendee: [#{attendee.attendee_number}] #{attendee.name}"
        attendee.send_sms(template.content)
        puts "OK"
      rescue => e
        puts "ERROR: #{e.message}"
      end
      puts '-----------------------------------'
      sleep 2
    end
  end
end