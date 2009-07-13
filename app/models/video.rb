require 'aasm'
class Video < Item
  # state machine modelling
  
  validate_on_create :video_limits
  
  include AASM
  aasm_column :status
  aasm_initial_state :pending
  
  aasm_state :pending
  aasm_state :processing, :enter => :convert_video
  aasm_state :ready, :enter => :set_new_filename
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
  
  # associations statements
  belongs_to :project
  
  # callbacks
  after_create :queue_conversion
  
  # paperclip attachements
  has_attached_file :source
  
  # paperclip validations, these break the rspec tests
  validates_attachment_presence :source 
  #validates_attachment_content_type :source, :content_type => 'video/quicktime' # only allowing quicktime videos to be uploaded
  validates_attachment_size :source, :less_than => 16.megabytes
  
  def video_limits
    unless self.project.user.can_add_videos?
      errors.add_to_base("You cannot add any more videos, upgrade plan or remove old videos.")
    end
  end
  
  def queue_conversion
    ProcessorWorker.async_video_processor(:video_id => self.id)
  end
  
  def convert_video
    success = system(convert_command)
    if success && $?.exitstatus == 0
      generate_stills
      true
    else
      false
    end
  end
  
  def display_thumbnail
    self.source.url(:thumb).gsub!(/video.flv/,"thumb.jpg")
  end
  
  def display_long
    self.source.url(:long).gsub!(/video.flv/,"long.jpg")
  end
  
  protected
  
  def convert_command
    flv = File.join(File.dirname(source.path), "#{id}-video.flv")
    File.open(flv, 'w')
    command = "ffmpeg -i #{source.path} -ar 22050 -ab 32 -acodec libmp3lame -vcodec flv -r 25 -s vga -qscale 8 -f flv -y #{flv}"
    logger.debug command
    command.gsub!(/\s+/," ")
  end
  
  def set_new_filename
    update_attribute(:source_file_name, "#{id}-video.flv")
  end
  
  def generate_stills
    if system(still_image_command)
      a = source.path.split("/")
      base_path = a.slice(0, (a.size - 2)).join("/")
      thumb_path = base_path + "/thumb/"
      long_path = base_path + "/long/"
      Paperclip.run thumbnail_command(thumb_path)
      Paperclip.run long_command(long_path)
    end
  end
  
  def still_image_command
    still = File.join(File.dirname(source.path), "#{id}-still.jpg")
    File.open(still, 'w')
    command = "ffmpeg -i #{source.path} -an -ss 00:00:01 -an -r 1 -vframes 1 -f mjpeg -y #{still}"
    logger.debug command
    command.gsub!(/\s+/," ")
  end
    
  def thumbnail_command(path)
    FileUtils.mkdir_p path
    still = File.join(File.dirname(source.path), "#{id}-still.jpg")
    thumb = File.join(path, "#{id}-thumb.jpg")
    File.open(thumb, 'w')
    command = "convert #{still} -thumbnail '50x50^' -gravity center -extent 50x50 #{thumb}"
    logger.debug command
    command.gsub!(/\s+/," ")
  end
  
  def long_command(path)
    FileUtils.mkdir_p path
    still = File.join(File.dirname(source.path), "#{id}-still.jpg")
    long = File.join(path, "#{id}-long.jpg")
    File.open(long, 'w')
    command = "convert #{still} -thumbnail 600x150^ -gravity center -extent 600x150 #{long}"
    logger.debug command
    command.gsub!(/\s+/," ")
  end
end
