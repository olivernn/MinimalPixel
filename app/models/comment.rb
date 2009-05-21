class Comment < ActiveRecord::Base
  belongs_to :article
  
  validates_presence_of :name, :content
  
  default_scope :order => "created_at DESC"
end
