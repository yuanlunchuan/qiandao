class BadgePdf < Prawn::Document
    def initialize(attendee, options={})
      pdf_options = {page_size: [154, 246], page_layout: :portrait, top_margin: 10, left_margin: 5, right_margin: 5, bottom_margin:0}
      if options[:background]
        background = "#{Rails.root}/app/pdfs/badge_background.png"
        pdf_options.merge!({background: background, background_scale: 0.25})
      end

      super(pdf_options)

      photo_path = attendee.avatar.path || "#{Rails.root}/app/pdfs/no_avatar.jpg"
      image photo_path, width: 60, height: 60, position: :center, vposition: 53

      # stroke_color 50, 100, 0, 0
      # stroke_rectangle [0, 243], 153, 243

      font_families.update(
         'msyh' => { normal: "#{Rails.root}/app/fonts/msyh.ttf" }
      )

      move_down 60

      font('msyh') do
        text attendee.name, align: :center, size: 14
        move_down 5
        text attendee.company, align: :center, size: 8
      end

      image attendee.qrcode_image, width: 45, height: 45, position: :center, vposition: 152

    end
end