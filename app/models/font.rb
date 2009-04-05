class Font < ActiveRecord::Base
  # allowing font uploads
  has_attached_file :font,
    :url => "/fonts/:basename.:extension",
    :path => ":rails_root/public/fonts/:basename.:extension"
  
  # validation statements
  validates_presence_of :name
  validates_attachment_presence :font
  validates_attachment_content_type :font, :content_type => 'application/x-shockwave-flash'

  # association statements
  has_many :styles
  
  # class methods
  def self.random
    find(:all).at(rand(count))
  end
  
  # instance methods
  def sifr_name
    self.font.original_filename.chop.chop.chop.chop
  end
end
