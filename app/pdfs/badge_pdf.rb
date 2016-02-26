class BadgePdf < Prawn::Document
    def initialize(attendee, options={})
      pdf_options = {page_size: [154, 246], page_layout: :portrait, top_margin: 10, left_margin: 5, right_margin: 5, bottom_margin:0}
      background = "#{Rails.root}/app/pdfs/guanzhou_red_background.png"
      if '经销商'==attendee.category.try(:name)
        background = "#{Rails.root}/app/pdfs/guanzhou_blue_background.png"
      end

      pdf_options.merge!({background: background, background_scale: 0.25})

      super(pdf_options)
      photo_path = attendee.avatar.path || "#{Rails.root}/app/pdfs/no_avatar.jpg"
      image photo_path, width: 100, height: 100, position: :center, vposition: 50

      #stroke_color 225, 0, 0, 0
      #stroke_rectangle [0, 243], 153, 243

      font_families.update(
         'msyh' => { normal: "#{Rails.root}/app/fonts/msyh.ttf" }
      )

      move_down 58

      font('msyh') do
        text attendee.name, align: :center, size: 14
        move_down 10
        company = ' '
        company = attendee.company if attendee.company.present?
        text company, align: :center, size: 8
        move_down 20
        text attendee.category.try(:name), align: :center, size: 9, color: "FFFFFF"
      end

      #image attendee.qrcode_image, width: 45, height: 45, position: :center, vposition: 152

    end
end