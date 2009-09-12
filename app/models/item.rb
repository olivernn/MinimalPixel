class Item < ActiveRecord::Base
  # acts_as_ .....
  acts_as_list :scope => "project_id"
  
  # association statements
  belongs_to :project
  
  # scopes
  named_scope :ready, :conditions => {:status => 'ready'}, :order => 'position'
  
  # validation statements
  validates_presence_of :name
  validates_length_of :name, :maximum => 30
  validates_date :date, :allow_nil => true
  
  attr_accessible :name, :description, :source, :facebook_upload
  
  attr_accessor :facebook_upload
  
  # override to_param method to get prettier urls
  def to_param
    "#{self.id}-#{self.name.parameterize.to_s}"
  end
  
  # need to hault the automatic processing unless this is being run by the background processor.
  # also cannot start the background job here on creation because the image wont have been saved yet!
  # this has to be done by process_images or process_videos
  def hault_processing
    if self.processing?
      true
    else
      false
    end
  end
end
