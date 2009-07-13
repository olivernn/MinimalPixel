class Image < Item
  has_attached_file :source,
  
    :styles => {
      :thumb => "50x50#",
      :long   => "600x150#",
      :normal => "500x500>",
      :large => "600x600>"
    }
    
    # During initial testing storage will be the filesystem
    # :storage => :s3,
    # :s3_credentials => "#{RAILS_ROOT}/config/s3.yml"
    
  before_post_process :hault_processing
  after_create :process_images
  
  validate_on_create :image_limits
  
  # state maching modelling
  include AASM
  aasm_column :status
  aasm_initial_state :pending

  aasm_state :pending
  aasm_state :processing
  aasm_state :ready
  aasm_state :error

  aasm_event :start_processing do
    transitions :to => :processing, :from => [:pending, :ready]
  end

  aasm_event :end_processing do
    transitions :to => :ready, :from => [:processing]
  end
  
  aasm_event :error do
    transitions :to => :error, :from => [:processing]
  end
  
  validates_attachment_presence :source
  validates_attachment_size :source, :less_than => 5.megabytes, :message => "must be less than 5MB"
  # TODO: need to check that we really can support all of these formats!
  validates_attachment_content_type :source, :content_type => ['image/gif', 'image/png', 'image/jpeg', 'image/tiff', 'image/pict']

  def display_thumbnail
    self.source.url(:thumb)
  end

  def display_long
    self.source.url(:long)
  end
  
  # this method gets run after creation, it will set up the background job to process the upload
  def process_images
    ProcessorWorker.async_image_processor(:image_id => self.id)
  end
  
  def image_limits
    unless self.project.user.can_add_images?
      errors.add_to_base("You cannot add any more images, upgrade plan or remove old images.")
    end
  end
end
