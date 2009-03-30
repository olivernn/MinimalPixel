class Plan < ActiveRecord::Base
  # validation statements
  validates_presence_of :name, :price, :payment_frequency, :available, :project_limit, :image_limit, :video_limit
  validates_numericality_of :price, :project_limit, :image_limit, :video_limit
  validates_inclusion_of :payment_frequency, :in => %w(Weekly Monthly Annually)
  
  # named scopes
  named_scope :offerable, :conditions => {:available => true}
  
  # relationships
  has_many :users, :through => :accounts, :source => :user
  has_many :accounts
  
  def free?
    !(self.price > 0)    
  end
end
