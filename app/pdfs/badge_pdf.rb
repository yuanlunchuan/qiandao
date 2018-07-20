class BadgePdf < Prawn::Document
    def initialize(attendee, options={})
      pdf_options = {page_size: [154, 246], page_layout: :portrait, top_margin: 10, left_margin: 5, right_margin: 5, bottom_margin:0}
      background = "#{Rails.root}/app/pdfs/pdfbackground.png"

      pdf_options.merge!({background: background, position: :center, background_scale: 0.24})

      super(pdf_options)
      photo_path = attendee.avatar.path || "#{Rails.root}/app/pdfs/no_avatar.jpg"
      image photo_path, width: 70, height: 70, position: :center, vposition: 50

      font_families.update(
         'msyh' => { normal: "#{Rails.root}/app/fonts/msyh.ttf" }
      )

      move_down 72
      
      category_color = '00ff00'
      if attendee.category.present?&&attendee.category.category_color.present?
        category_color = attendee.category.category_color.delete '#'     
      end
      fill_color category_color
      stroke_color category_color
      fill_and_stroke_rounded_rectangle [-10,36], 200, 24, 0
      fill_color '000000'

      font('msyh') do
        text attendee.name, align: :center, size: 14
        move_down 10
        company = ' '
        company = attendee.company if attendee.company.present?
        
        if company.length>12
          text company[0,12], align: :center, size: 10
          move_down 2
          text company[12, company.length], align: :center, size: 10
          move_down 16
        end
        
        if company.length<=12
           text company, align: :center, size: 10
           move_down 29
         end
        text attendee.category.try(:name), align: :center, size: 9, color: "FFFFFF"
      end

      #image attendee.qrcode_image, width: 45, height: 45, position: :center, vposition: 152

    end
end
