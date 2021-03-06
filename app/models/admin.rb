class Admin < ActiveRecord::Base
  has_secure_password

  has_many :answers
  belongs_to :company

  before_create { generate_token(:auth_token) }

  scope :auth_token_is, ->(auth_token){ where auth_token: auth_token }


  #validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :phone_number, presence: true, uniqueness: {case_sensitive: false}

  def name=(name)
    write_attribute(:name, name.try(:strip))
  end

private

  def strip_whitespace
    self.name = self.name.strip
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64 30
    end while Admin.exists?(column => self[column])
  end
end
