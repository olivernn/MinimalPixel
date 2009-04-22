class Page < ActiveRecord::Base
  # validation statements
  validates_presence_of :title, :permalink, :content
  validates_uniqueness_of :permalink, :scope => :user_id
  
  # association statements
  belongs_to :user
  
  # callbacks
  before_validation_on_create :create_permalink
  
  # acts_as.....
  acts_as_textiled :content
  
  attr_protected :permalink
  
  def to_param
    permalink
  end
  
  private
  
  def create_permalink
    self.permalink = CGI.escape(self.title.gsub(' ', '_')) if self.title
  end
end
