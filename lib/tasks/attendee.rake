require 'csv'

namespace :attendee do
  desc '导入报名人员'
  task :import, [:csv_file, :event_id] => :environment do |t, args|
    next unless args[:csv_file]
    next unless args[:event_id]

    event_id = args[:event_id].to_i
    event = Event.find(event_id)

    CSV.foreach(args[:csv_file],
                    headers: true,
                    converters: :all,
                    header_converters: lambda do |h|
                      mapping = {
                          '省' =>          :province ,
                          '市' =>          :city,
                          '经销商名称'=>    :company,
                          '姓名' =>        :name,
                          '手机' =>        :mobile,
                          '性别' =>        :gender,
                          '标签' =>        :category
                      }

                      mapping[h]
                    end) do |row|

      next unless row[:name]

      params = {}

      params[:province]    = row[:province]
      params[:city]        = row[:city]
      params[:company]     = row[:company]
      params[:name]        = row[:name]
      params[:mobile]      = row[:mobile]
      params[:gender_id]   = (row[:gender] == '男' ? 0 : 1)
      params[:category_id] = event.attendee_categories.find_by_name(row[:category]).try(:id)

      if params[:mobile] && event.attendees.find_by_mobile(params[:mobile])
        puts "************ #{params[:name]} 电话重复 *************"
        next
      end

      a = event.attendees.create!(params)

      puts "#{a.id} - #{a.name}"

    end

  end
end