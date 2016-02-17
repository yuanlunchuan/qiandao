class BadgePdf < Prawn::Document
    def initialize(attendee, options={})
      pdf_options = {page_size: [154, 246], page_layout: :portrait, top_margin: 10, left_margin: 5, right_margin: 5, bottom_margin:0}
      # if options[:background]
      background = "#{Rails.root}/app/pdfs/badge_background(2).png"
      if '经销商'==attendee.category.try(:name)
        background = "#{Rails.root}/app/pdfs/badge_background(3).png"
      end

      pdf_options.merge!({background: background, background_scale: 0.25})
      # end

      super(pdf_options)
      photo_path = attendee.avatar.path || "#{Rails.root}/app/pdfs/no_avatar.jpg"
      image photo_path, width: 80, height: 80, position: :center, vposition: 80

      # stroke_color 50, 100, 0, 0
      # stroke_rectangle [0, 243], 153, 243

      font_families.update(
         'msyh' => { normal: "#{Rails.root}/app/fonts/msyh.ttf" }
      )

      move_down 88

      font('msyh') do
        text attendee.name, align: :center, size: 14
        move_down 5
        text attendee.company, align: :center, size: 8
        move_down 17
        text attendee.category.try(:name), align: :center, size: 12
      end

      #image attendee.qrcode_image, width: 45, height: 45, position: :center, vposition: 152

    end
end