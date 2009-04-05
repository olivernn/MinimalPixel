class Image < Item
  has_attached_file :source,
    :styles => {
      :thumb => "100x100#",
      :long   => "500x150#",
      :normal => "500x500>",
      :large => "600x600>"
    }
    
    # During initial testing storage will be the filesystem
    # :storage => :s3,
    # :s3_credentials => "#{RAILS_ROOT}/config/s3.yml"
    
    validates_attachment_presence :source
    validates_attachment_size :source, :less_than => 5.megabytes
    # TODO: need to check that we really can support all of these formats!
    validates_attachment_content_type :source, :content_type => ['image/gif', 'image/x-png', 'image/jpeg', 'image/tiff', 'image/x-pict']
end
