class SystemInfo < ActiveRecord::Base
  belongs_to :event

  scope :visible, -> { where(display: true) }

  def to_hash
    hash = {}
    self.attributes.each { |k,v| hash[k] = v }
    return hash
  end
end
