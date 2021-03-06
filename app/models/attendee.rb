require 'rqrcode_png'
class Attendee < ActiveRecord::Base
  has_many :sub_attendees, class_name: "Attendee",
                          foreign_key: "attendee_id"

  belongs_to :owner_attendee, class_name: "Attendee"

  GENDER = { '男' => 0, '女' => 1}
  validates :rfid_num, allow_blank: true, uniqueness: true
  has_attached_file :photo,
                    styles: { medium: "300x300>", square:'300x300#', thumb: "100x100>", large: '1000x1000>'},
                    url: '/system/events/:style/:mobile.jpg',
                    default_url: 'avatar.png'

  has_attached_file :avatar,
                    styles: {original: '400x400>'},
                    url: '/system/events/avatar/:mobile.jpg',
                    default_url: 'avatar.png'

  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  belongs_to :event
  belongs_to :category, class_name: 'AttendeeCategory'
  has_many   :question
  belongs_to :seller
  has_one    :seat

  has_many :checkins
  has_many :sessions, through: :checkins
  has_many :lottery_prizes
  has_many :attendee_praises_questions

  scope :rfid_is, -> (rfid) { where rfid_num: rfid }
  scope :mobile_is, -> (mobile) { where mobile: mobile }
  scope :attendee_name_is, ->(name) { where name: name }
  scope :token_is, ->(token) { where token: token}

  scope :seller_is, -> (seller) { where seller_id: seller.id }
  scope :company_is, -> (company) { where company: company }
  scope :printed, -> {where('printed_at IS NOT NULL')}
  scope :not_printed, -> {where('printed_at IS NULL')}

  scope :has_photo, -> { where('photo_file_name IS NOT NULL') }
  scope :does_not_have_photo, -> { where('photo_file_name IS NULL') }
  scope :has_avatar, -> { where('avatar_file_name IS NOT NULL') }
  scope :does_not_have_avatar, -> { where('avatar_file_name IS NULL') }
  scope :does_not_processed_avatar, -> { where('photo_file_name IS NOT NULL AND avatar_file_name IS NULL') }

  scope :category,  -> (category_id) { where(category_id: category_id) }
  scope :checked_in, -> { where('checked_in_at IS NOT NULL') }
  scope :sms_sent,   -> { where('sms_sent_at IS NOT NULL') }
  scope :sms_not_sent,   -> { where('sms_sent_at IS NULL') }
  scope :not_checked_in, -> { where('checked_in_at IS NULL')}
  scope :contains, ->(keyword) { where('name like :keyword OR mobile like :keyword OR company like :keyword OR province like :keyword OR city like :keyword', keyword: "%#{keyword}%") }

  default_scope -> {order(attendee_number: :asc)}
  scope :city_is, ->(city) { where city: city }
  scope :seller_id_is, ->(seller_id) { where seller_id: seller_id }
  scope :is_sub_attendees, -> { where 'owner_attendee_id IS NULL' }

  before_create { generate_token(:token) }
  after_create  { generate_invitation_short_url }
  after_create  { generate_qrcode }

=begin  before_save { generate_photo }
  before_save { generate_avatar }

  before_update { generate_photo }
  before_update { generate_avatar }
=end

  validate :valid_mobile?

=begin
  def generate_photo
    if self.photo.blank?&&self.mobile.present?
      attendee = Attendee.has_photo.mobile_is(self.mobile).first
      if attendee.present?
        self.photo_file_name = attendee.photo_file_name
        self.photo_content_type = attendee.photo_content_type
        self.photo_file_size = attendee.photo_file_size
      end
    end
  end

  def generate_avatar
    if self.avatar.blank?&&self.mobile.present?
      attendee = Attendee.has_avatar.mobile_is(self.mobile).first
      if attendee.present?
        self.avatar_file_name = attendee.avatar_file_name
        self.avatar_content_type = attendee.avatar_content_type
        self.avatar_file_size = attendee.avatar_file_size
      end
    end
  end
=end

  def valid_mobile?
    if self.mobile.present?
      errors.add(:mobile, "手机号不正确，请检查手机号码。") if self.mobile.length<11
      attendee = self.event.attendees.mobile_is(self.mobile).first
      errors.add(:mobile, "同一个活动中电话号码不能重复") if attendee.present?&&(attendee.id!=self.id)
    end
  end

  def self.has_lottery_prize(event_lottery_prize)
    self.joins('INNER JOIN lottery_prizes on lottery_prizes.attendee_id = attendees.id').where( "lottery_prizes.state = 'F' AND lottery_prizes.event_lottery_prize_id=?", event_lottery_prize.id)
  end

  def self.has_arranged(session)
    self.joins('LEFT OUTER JOIN seats ON seats.attendee_id = attendees.id').select('distinct(attendees.id), attendees.*').where( 'seats.session_id=?', session.id)
  end

  def self.not_arrange(session)
    self.joins('LEFT OUTER JOIN seats ON seats.attendee_id = attendees.id').select('distinct(attendees.id), attendees.*').where( 'attendees.id NOT IN (SELECT attendee_id FROM seats where seats.session_id=?)', session.id)
  end

  def generate_qrcode
    qr = RQRCode::QRCode.new(self.token, :size => 4, :level => :h )
    png = qr.to_img
    unless File.directory? "#{Rails.root}/public/attendee_qrcode"
      Dir::mkdir("#{Rails.root}/public/attendee_qrcode", 0777)
    end
    png.resize(150, 150).save("#{Rails.root}/public/attendee_qrcode/#{self.event_id}_#{self.id}.png")
  end

  def gender
    GENDER.invert[gender_id]
  end

  def qrcode
    ##{self.token}/#{serial_number}"
    "#{self.token}"
  end

  def qrcode_image
    file = "#{Rails.root}/public/system/qrcodes/#{self.qrcode}.png"
    unless File.exists?(file)
      FileUtils.mkdir_p(File.dirname(file))
      RQRCode::QRCode.new(self.qrcode, size: 5, level: :h).as_png(file: file)
    end
    file
  end

  def serial_number
    "#{self.event_id}-#{self.attendee_number}"
  end

  def checked_in?
    self.checked_in_at.present?
  end

  def sms_sent?
    self.sms_sent_at.present?
  end

  def session_checked_in(session_id)
    self.checkins.where(session_id: session_id).first
  end

  def invitation_url
    self.invitation_short_url || self.invitation_long_url
  end

  def invitation_long_url
    if self.event.id==30
      "#{ENV['HOSTNAME']}/client/events/#{self.event.id}/sites?attendee_id=#{self.id}"
    else
      "#{ENV['HOSTNAME']}/client/events/#{self.event.id}/invites"
    end
  end

  def send_sms(template)
    template = prepare_sms_template template
    raise '该用户没有手机号码' if self.mobile.blank?

    Rails.logger.info("[SMS] Send SMS to #{self.mobile} (#{self.attendee_number}: #{self.name})")

    ret = Timeout::timeout(5) do
      http = Net::HTTP.post_form(URI.parse('http://yunpian.com/v1/sms/send.json'),{mobile: self.mobile, text: template, apikey: ENV["YUNPIAN_APIKEY"]})
      http.body
    end

    json = JSON.parse(ret)
    # 发送成功
    if json['code'] == 0
      self.sms_sent_at        = Time.now
      self.sms_sid            = json['result']['sid']
      self.sms_failed         = false
      self.sms_error          = ''
      self.save
    # 发送失败
    else
      error = "#{json['msg']} #{json['detail']}"
      raise error
    end
  rescue => e
    error = "#{e.class} - #{e.message[0..200]}"
    Rails.logger.error("[SMS] #{error}")

    self.sms_failed = true
    self.sms_error = error
    self.save
    raise error
  end

  def generate_invitation_short_url
    if self.invitation_short_url.blank?
      url = self.invitation_long_url # //generate_short_url(self.invitation_long_url)
      self.update_attribute(:invitation_short_url, url)
    end
  rescue => e
    error = "#{e.class} - #{e.message[0..200]}"
    Rails.logger.error("[DWZ] #{error}")
    raise error||""
  end

  def prepare_sms_template(template)
    template = template.gsub(/#name#/, self.name)
    template = template.gsub(/#url#/, self.invitation_url)
    template
  end

  def to_hash
    hash = {}
    self.attributes.each { |k,v| hash[k] = v }
    return hash
  end

  before_validation :populate_attendee_number, on: :create

private
  def generate_short_url(long_url)
    Rails.logger.info("[DWZ] Generate Short URL: #{long_url}")
    ret = Timeout::timeout(5) do
      # http = Net::HTTP.post_form(URI.parse('http://dwz.cn/create.php'),{url: long_url})
      Net::HTTP.get(URI.parse("https://api.weibo.com/2/short_url/shorten.json?source=1681459862&url_long=#{long_url}"))
    end
    json = JSON.parse(ret)
    if json['urls']
      json['urls'][0]['url_short']
    elsif json['error']
      'app/model/attendee/150'
      #raise json['error']
    else
      raise json['err_msg']
    end
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64(5).downcase
    end while Attendee.exists?(column => self[column])
  end

  def populate_attendee_number
    max_number = self.event.attendees.maximum(:attendee_number) || 0
    self.attendee_number = max_number + 1
  end
end
