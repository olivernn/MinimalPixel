class Plan < ActiveRecord::Base
  # validation statements
  validates_presence_of :name, :price, :payment_frequency, :available, :project_limit, :image_limit, :video_limit
  validates_numericality_of :price, :project_limit, :image_limit, :video_limit
  validates_inclusion_of :payment_frequency, :in => %w(Day Week Month Year)
  
  # named scopes
  named_scope :offerable, :conditions => {:available => true}
  named_scope :chargeable, :conditions => 'price > 0'
  
  # relationships
  has_many :users, :through => :accounts, :source => :user
  has_many :accounts
  
  def free?
    !(self.price > 0)    
  end
  
  def payment_profile
    {:amount => self.price,
     :description => "Minimal Pixel #{self.name} Subscription",
     :period => self.payment_frequency,
     :frequency => 1,
     :auto_bill_outstanding => false,
     :start_date => Time.now}
  end
end
