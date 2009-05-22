class Comment < ActiveRecord::Base
  belongs_to :article
  
  validates_presence_of :name, :content
  
  default_scope :order => "created_at"
  
  def datetime
    self.created_at.strftime("%d %b %Y at %I:%M%p")
  end
end
