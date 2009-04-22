class Profile < ActiveRecord::Base
  
  has_attached_file :photo,
    :styles => {
      :sidebar => '170x170>'
    }
    
  # validation statements
  validates_format_of :web, :with => URI::regexp(%w(http https)), :allow_blank => true, :allow_false => true
  validates_attachment_size :photo, :less_than => 2.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/gif', 'image/x-png', 'image/jpeg', 'image/tiff', 'image/x-pict']
  
  # association statements
  belongs_to :user
end
